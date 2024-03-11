FactoryBot.define do
  factory :owner do
    first_name {"Alex"}
    last_name {"Heimann"}
    street {"10152 Sudberry Drive"}
    city {"Wexford"}
    state {"PA"}
    zip {"15090"}
    association :user
    active {true}
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    email { |a| "#{a.first_name}.#{a.last_name}@example.com".downcase }
  end
end
