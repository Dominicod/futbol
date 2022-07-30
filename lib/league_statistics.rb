class LeagueStatistics
  def initialize(data_set)
    @data_set = data_set
  end

  def count_of_teams
    team_id_array = []
    @data_set[:game_teams].each do |row|
      team_id_array << row[1]
    end
    team_id_array.uniq.count
  end

  def total_team_goal_averages
    teams_goals_hash = {}
    @data_set[:game_teams].each do |row|
      if teams_goals_hash[row[:team_id]] == nil
        teams_goals_hash[row[:team_id]] = []
      end
      teams_goals_hash[row[:team_id]] << row[:goals].to_f
    end
    average_teams_goals = teams_goals_hash.each do |team, goals|
      teams_goals_hash[team] = (goals.sum / goals.count).round(2)
    end
    average_teams_goals
  end

  def best_offense
    best_team = total_team_goal_averages.max_by {|team, average| average}
    best_team_name = ""
    @data_set[:teams].each do |row|
      if row[:team_id] == best_team[0]
        best_team_name = row[:teamname]
      end
    end
    best_team_name
  end

  def worst_offense
    worst_team = total_team_goal_averages.min_by {|team, average| average}
    worst_team_name = ""
    @data_set[:teams].each do |row|
      if row[:team_id] == worst_team[0]
        worst_team_name = row[:teamname]
      end
    end
    worst_team_name
  end
end
