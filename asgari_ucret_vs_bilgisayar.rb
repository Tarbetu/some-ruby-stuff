# frozen_string_literal: true

def fill_map(map, data_arr)
  (1..2023 - 2005).each.with_index(2005) do |index, year|
    map[year] = data_arr[index - 1]
  end
end

required_dollar_for_a_pc = 1000

minimum_wage_for_years_tl = [350, 380, 403, 481, 527,
                             576, 629, 701, 773, 846,
                             949, 1300, 1404, 1603, 2020,
                             2324, 2825, 4253]
minimum_wage_map = {}

fill_map(minimum_wage_map, minimum_wage_for_years_tl)

tl_dollar_rate_for_years = [1.34, 1.43, 1.30, 1.29, 1.54,
                            1.50, 1.67, 1.79, 1.90, 2.18,
                            2.72, 3.02, 3.64, 4.81, 5.67,
                            7.01, 8.91, 14.69]
tl_dollar_rate_map = {}
fill_map(tl_dollar_rate_map, tl_dollar_rate_for_years)

required_tl_for_a_pc_map = {}
tl_dollar_rate_map.each do |year, rate|
  required_tl_for_a_pc_map[year] = required_dollar_for_a_pc * rate
end

puts <<~HEADER
  Yıllara Bir Bilgisayara Vermeniz Gereken para
  _____________________________________________
  Yıl - Bilgisayar Parası - Asgari Ücretin Kaç Katı?
HEADER

required_tl_for_a_pc_map.each do |year, price|
  puts "#{year} - #{price.round} - #{(price / minimum_wage_map[year]).round(2)}"
end
