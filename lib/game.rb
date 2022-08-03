require_relative 'uniquable.rb'
class Game
  include Uniquable
  def initialize(data)
    @data = data
    @total_away_wins = @data[:games].count do |row| 
      row[:away_goals].to_i > row[:home_goals].to_i
    end
    @total_home_wins = @data[:games].count do |row| 
      row[:home_goals].to_i > row[:away_goals].to_i
    end
    @total_ties = @data[:games].count do |row| 
      row[:home_goals].to_i == row[:away_goals].to_i
    end
    @total_games = @data[:games].count
    @total_goals = total_goals()
  end

  def lowest_total_score
    ordered_total_score(:lowest)
  end

  def highest_total_score
    ordered_total_score(:highest)
  end

  def ordered_total_score(option)
    goals = @total_goals
    option == :highest ? goals.max : goals.min
  end

  def percentage_home_wins
    (@total_home_wins.to_f / @total_games.to_f).round(2)
  end

  def percentage_visitor_wins
    (@total_away_wins.to_f / @total_games.to_f).round(2)
  end

  def percentage_ties 
    (@total_ties.to_f / @total_games.to_f).round(2)
  end

  def count_of_games_by_season
    result = Uniquable.unique_seasons_hash(@data)
    result[1].each do |key, _value|
      result[1][key] = result[0].count {|row| row[:season] == key}
    end
  end

  def average_goals_per_game
    (@total_goals.sum / @total_games).round(2)
  end

  def average_goals_by_season
    #goals per season / season game count
    result = Uniquable.unique_seasons_hash(@data)
    result[1].map do |key, _value|
      result[0].map do |row|
        result[1][key] << (row[:home_goals].to_f + row[:away_goals].to_f) if row[:season] == key
      end
    end
    total = result[1].transform_values { |value| value.count }
    sum = result[1].transform_values { |value| value.sum }
    result[1].each {|key, _value| result[1][key] = (sum[key] / total[key]).round(2)}
  end

  def total_goals
    @data[:games].map do |row| 
      row[:away_goals].to_f + row[:home_goals].to_f
    end
  end
end
