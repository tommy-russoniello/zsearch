class ApplicationControllerTest < ActionDispatch::IntegrationTest
  def setup
    @tag = Tag.create!(name: 'tag')
    @other_tag = Tag.create!(name: 'other tag')

    @organization = Organization.create!(
      details: 'details',
      external_id: 'organization external_id',
      name: 'organization name',
      shared_tickets: true,
      url: 'url'
    )

    @other_organization = Organization.create!(
      details: 'other details',
      external_id: 'other organization external_id',
      name: 'other organization name',
      shared_tickets: true,
      url: 'other url'
    )

    @user = User.create!(
      active: true,
      alias: 'alias',
      email: 'user@example.com',
      external_id: 'user external_id',
      last_login_at: Time.zone.now,
      locale: 'locale',
      name: 'user name',
      organization: @organization,
      phone: 'phone',
      role: 'admin',
      shared: true,
      signature: 'signature',
      suspended: true,
      timezone: 'timezone',
      url: 'user url',
      verified: true
    )

    @other_user = User.create!(
      active: true,
      alias: 'other alias',
      email: 'other_user@example.com',
      external_id: 'other user external_id',
      last_login_at: Time.zone.now,
      locale: 'other locale',
      name: 'other user name',
      organization: @other_organization,
      phone: 'other phone',
      role: 'admin',
      shared: true,
      signature: 'other signature',
      suspended: true,
      timezone: 'other timezone',
      url: 'other user url',
      verified: true
    )

    @ticket = Ticket.create!(
      uuid: 'uuid',
      assignee: @user,
      description: 'description',
      due_at: 1.week.from_now,
      external_id: 'ticket external_id',
      has_incidents: true,
      id: 1,
      organization: @organization,
      priority: 'high',
      status: 'open',
      subject: 'subject',
      submitter: @user,
      tags: [@tag, @other_tag],
      ticket_type: 'task',
      url: 'ticket url',
      via: 'web'
    )

    @other_ticket = Ticket.create!(
      uuid: 'other uuid',
      assignee: @other_user,
      description: nil,
      due_at: 1.week.from_now,
      external_id: 'other ticket external_id',
      has_incidents: false,
      id: 9,
      organization: @other_organization,
      priority: 'high',
      status: 'open',
      subject: 'other subject',
      submitter: @other_user,
      tags: [@other_tag],
      ticket_type: 'task',
      url: 'other ticket url',
      via: 'web'
    )

    @another_ticket = Ticket.create!(
      uuid: 'another uuid',
      assignee: @user,
      description: nil,
      due_at: 1.week.from_now,
      external_id: 'another ticket external_id',
      has_incidents: true,
      id: 99,
      organization: @organization,
      priority: 'high',
      status: 'closed',
      subject: 'another subject',
      submitter: @user,
      tags: [@tag],
      ticket_type: 'task',
      url: 'another ticket url',
      via: 'web'
    )
  end

  def teardown
    OrganizationDomainName.delete_all
    OrganizationTag.delete_all
    TicketTag.delete_all
    UserTag.delete_all
    Tag.delete_all
    DomainName.delete_all
    Ticket.delete_all
    User.delete_all
    Organization.delete_all
  end

  test('index - with results') do
    get(tickets_path)
    assert_results([@ticket, @other_ticket, @another_ticket])
  end

  test('index - without results') do
    @ticket.delete
    @other_ticket.delete
    @another_ticket.delete
    get(tickets_path)
    assert_no_results
  end

  test('show') do
    get(ticket_path(@ticket))
    assert_result(@ticket)
  end

  test('search - no fields selected') do
    get(ticket_search_path)
    assert_no_results
  end

  test('search - on string field') do
    get("#{ticket_search_path}?search=other&fields[subject]=true")
    assert_results([@other_ticket, @another_ticket])
  end

  test('search - on number field') do
    get("#{ticket_search_path}?search=9&fields[id]=true")
    assert_results([@other_ticket, @another_ticket])
  end

  test('search - on boolean field - with matching string - true') do
    get("#{ticket_search_path}?search=true&fields[has_incidents]=true")
    assert_results([@ticket, @another_ticket])
  end

  test('search - on boolean field - with matching string - false') do
    get("#{ticket_search_path}?search=false&fields[has_incidents]=true")
    assert_results([@other_ticket])
  end

  test('search - on boolean field - with non-matching string') do
    get("#{ticket_search_path}?search=alse&fields[has_incidents]=true")
    assert_no_results
  end

  test('search - on boolean field - with number - true') do
    get("#{ticket_search_path}?search=1&fields[has_incidents]=true")
    assert_results([@ticket, @another_ticket])
  end

  test('search - on boolean field - with number - false') do
    get("#{ticket_search_path}?search=0&fields[has_incidents]=true")
    assert_results([@other_ticket])
  end

  test('search - on enum field - with matching string') do
    get("#{ticket_search_path}?search=open&fields[status]=true")
    assert_results([@ticket, @other_ticket])
  end

  test('search - on enum field - with non-matching string') do
    get("#{ticket_search_path}?search=ope&fields[status]=true")
    assert_no_results
  end

  test('search - on enum field - with number') do
    get("#{ticket_search_path}?search=#{Ticket.statuses[:open]}&fields[status]=true")
    assert_results([@ticket, @other_ticket])
  end

  test('search - on has many field - with matching string') do
    get("#{ticket_search_path}?search=other&fields[tags]=true")
    assert_results([@ticket, @other_ticket])
  end

  test('search - on has many field - with non-matching string') do
    get("#{ticket_search_path}?search=unknown&fields[tags]=true")
    assert_no_results
  end

  test('search - on empty field') do
    get("#{ticket_search_path}?search=&fields[description]=true")
    assert_results([@other_ticket, @another_ticket])
  end

  test('search - on empty has many') do
    TicketTag.where(ticket_id: @another_ticket.id).delete_all
    get("#{ticket_search_path}?search=&fields[tags]=true")
    assert_results([@another_ticket])
  end

  private

  def assert_no_results
    assert_select('a.result', count: 0)
  end

  def assert_result(model)
    assert_select('pre#result', count: 1) do |elements|
      data = JSON.parse(elements.first.text)
      assert_equal(Ticket.sort_attributes.size, data.size, 'attribute count')
      model.attributes.each do |attribute, value|
        if Ticket.attribute_types[attribute].type == :datetime
          assert_equal(value.change(usec: 0), data[attribute].to_datetime.change(usec: 0),
            attribute)
        else
          assert_equal(value, data[attribute], attribute)
        end
      end

      Ticket.has_many_attributes.each do |attribute|
        assert_equal(model.send(attribute).pluck(:name).sort, data[attribute].sort, attribute)
      end
    end
  end

  def assert_results(models)
    result_models = []
    text = []
    assert_select('a.result') do |elements|
      result_models = elements.map do |element|
        text << element.parent.text
        element.attributes['href'].value.split('/')[-1].to_i
      end
    end

    result_models.map! { |id| Ticket.find_by(id: id) }.compact!
    assert_equal(models.size, result_models.size, 'result count')

    sorted_result_models = result_models.sort_by(&:id)
    sorted_models = models.sort_by(&:id)

    assert_equal(sorted_models.pluck(:id), sorted_result_models.pluck(:id), 'result ids')
    assert_equal(result_models.pluck(Ticket.name_field), text, 'result text')
  end
end
