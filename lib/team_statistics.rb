require_relative 'uniquable.rb'

class TeamStatistics
  include Uniquable
  def initialize(data)
    @data = data
  end

  def team_info(team_id)
    # returns hash with team_id, franchise_id, team_name, abbreviation, and link
    team_index = @data[:teams][:team_id].index(team_id)
    team_info_return = @data[:teams][team_index].to_h.reject { |key, _value| key == :stadium }
    team_info_return[:team_name] = team_info_return.delete(:teamname)
    team_info_return[:franchise_id] = team_info_return.delete(:franchiseid)
    team_info_return.transform_keys { |key| key.to_s rescue key }
  end

  def best_season(team_id)
    # returns season with the highest win percentage for a team as string
    percentage(team_id, :highest_win)
  end

  def worst_season(team_id)
		# returns season with the lowest win percentage for a team as string
    percentage(team_id, :lowest_win)
  end

  def average_win_percentage(team_id)
    # returns average win percentage of all games for a team.
    percentage(team_id, :average_percent)
  end

  def most_goals_scored(team_id)
    goals_by_team_id(team_id).max
  end

  def fewest_goals_scored(team_id)
    goals_by_team_id(team_id).min
  end

  def favorite_opponent(team_id)

  end

  def rival(team_id)

  end



  def percentage(team_id, data_choice)
		# returns output based on data_choice input, calculates win and loss percentages
    module_return = Uniquable.unique_seasons_hash(@data)
    game_by_season = Uniquable.unique_season_by_id(team_id, module_return[0])
    total_season_hash = module_return[1].transform_values { |value| [0.0, 0.0, 0.0]}
    total_season_hash.each do |season, _value|
      game_by_season.each do |row|
				update_total_count(season,total_season_hash, row, team_id) if row[:season] == season
      end
    end
    
    total_season_hash.each do |_key, value|
      value[2] = value[0] - value[1]
      value[1] = (value[1] / value[0]).round(2)
      value[2] = (value[2] / value[0]).round(2)
    end

    highest_percent_arr = [0]
    lowest_percent_arr = [100]

    total_season_hash.map do |key, value| 
      highest_percent_arr[0] < value[1] ? highest_percent_arr = [value[1], key] : false
      value[1] < lowest_percent_arr[0] ? lowest_percent_arr = [value[1], key] : false
    end
    if data_choice == :highest_win
      highest_percent_arr[1]
    elsif data_choice == :lowest_win 
      lowest_percent_arr[1]
    else
      average_percent = (((total_season_hash.map {|_key, value| value[1]}).sum)/total_season_hash.count).round(2)
    end
  end
	
	def update_total_count(season, total_season_hash, row, team_id)
		# updates total_count hash with new values based on conditions
		total_season_hash[season][0] += 1
		if row[:home_team_id] == team_id
			total_season_hash[season][1] += 1 if row[:home_goals] > row[:away_goals]
		elsif row[:away_team_id] == team_id
			total_season_hash[season][1] += 1 if row[:away_goals] > row[:home_goals]
		end
	end
  
  def goals_by_team_id(team_id)
    team_goals = [] 
    @data[:game_teams].each do |row|
      if row[:team_id] == team_id
        team_goals << row[:goals].to_i
      end
    end
    team_goals
  end
end
