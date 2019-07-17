# rubocop:disable Rails/Output
%w[organizations users tickets].each do |seed|
  load(Rails.root.join('db', 'seeds', "seed_#{seed}.rb"))
  puts("#{seed} created")
end
# rubocop:enable Rails/Output
