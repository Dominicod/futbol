require './spec_helper'
require_relative '../lib/stat_tracker'
require_relative '../lib/season_statistics'
require 'pry'

RSpec.describe SeasonStatistics do
  before(:all) do
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    stat_tracker = StatTracker.from_csv(locations)
    @season_statistics = SeasonStatistics.new(stat_tracker.data)
  end

  describe '.SeasonStatistics Instantiation' do
    it 'is instance of class' do
      expect(@season_statistics).to be_an_instance_of(described_class)
    end
  end
  describe '.season_game_id_verification' do
    it 'verifies the season exists in the game id' do
      expect(@season_statistics.season_game_id_verification).to eq true
    end
  end
  describe '.winningest_coach' do
    it 'returns the winningest coach' do
      expect(@season_statistics.winningest_coach('20132014')).to eq 'Claude Julien'
      expect(@season_statistics.winningest_coach('20142015')).to eq 'Alain Vigneault'
    end
  end
  describe '.worst_coach' do
    it 'returns the lowest winning percentage coach' do
      expect(@season_statistics.worst_coach('20132014')).to eq 'Peter Laviolette'
      expect(@season_statistics.worst_coach('20142015')).to eq('Craig MacTavish').or(eq('Ted Nolan'))
    end
  end
  describe '.coach_percent' do
    it 'calculates the win percentage' do
      expect(@season_statistics.coach_percent('20132014')['Lindy Ruff']).to eq 0.39
      expect(@season_statistics.coach_percent('20132014')['Ken Hitchcock']).to eq 0.42
      expect(@season_statistics.coach_percent('20132014')['Craig Berube']).to eq 0.4
    end
  end
  describe '.most_accurate_team' do
    it 'names team with best ratio of shots to goals for season' do
      expect(@season_statistics.most_accurate_team('20132014')).to eq 'Real Salt Lake'
      expect(@season_statistics.most_accurate_team('20142015')).to eq 'Toronto FC'
    end
  end
  describe '.least_accurate_team' do
    it 'names team with best ratio of shots to goals for season' do
      expect(@season_statistics.least_accurate_team('20132014')).to eq 'New York City FC'
      expect(@season_statistics.least_accurate_team('20142015')).to eq 'Columbus Crew SC'
    end
  end
  describe '.most_tackles' do
    it 'names the team with the highest number of tackles' do
      expect(@season_statistics.most_tackles('20132014')).to eq 'FC Cincinnati'
      expect(@season_statistics.most_tackles('20142015')).to eq 'Seattle Sounders FC'
    end
  end
  describe '.fewest_tackles' do
    it 'names the team with the fewest number of tackles' do
      expect(@season_statistics.fewest_tackles('20132014')).to eq 'Atlanta United'
      expect(@season_statistics.fewest_tackles('20142015')).to eq 'Orlando City SC'
    end
  end
end
