module Uniquable
  def self.unique_seasons_hash(data)
    game_by_season = data[:games]
    total_season = (game_by_season.uniq { |season| season[:season] }).map { |season| season[:season] }
    total_count = {}
    total_season.each { |season| total_count.store(season, []) }
    [game_by_season, total_count]
  end

  def self.unique_season_by_id(team_id, games)
    season_by_id = (games.find_all do |row|
                      row[:home_team_id] == team_id || row[:away_team_id] == team_id
                    end).sort_by { |obj| obj[:season] }
  end
end
