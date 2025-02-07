require 'spec_helper'
require_relative '../lib/team_statistics'
require './lib/stat_tracker'

RSpec.describe TeamStatistics do
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
    @team_statistics = TeamStatistics.new(stat_tracker.data)
  end
  describe '.team_satistics instantiation' do
    it 'is instance of class' do
      expect(@team_statistics).to be_an_instance_of(TeamStatistics)
    end
  end
  describe '.team_info' do
    hash_output = {
      'team_id' => '1',
      'franchise_id' => '23',
      'team_name' => 'Atlanta United',
      'abbreviation' => 'ATL',
      'link' => '/api/v1/teams/1'
    }
    it 'returns team_id, franchise_id, team_name, abbreviation, and link' do
      expect(@team_statistics.team_info('1')).to eq(hash_output)
    end
  end
  describe '.best_season' do
    it 'returns season with highest win percentage' do
      expect(@team_statistics.best_season('6')).to eq('20132014')
    end
  end
  describe '.worst_season' do
    it 'returns season with lowest win percentage' do
      expect(@team_statistics.worst_season('6')).to eq('20142015')
    end
  end
  describe '.average_win_percentage' do
    it 'returns average_win_percentage' do
      expect(@team_statistics.average_win_percentage('6')).to eq(0.49)
    end
  end
  describe '.most_goals_scored' do
    it 'returns most goals scored in a game' do
      expect(@team_statistics.most_goals_scored('18')).to eq 7
    end
  end
  describe '.fewest_goals_scored' do
    it 'returns fewest goals scored in a game' do
      expect(@team_statistics.fewest_goals_scored('18')).to eq 0
    end
  end
  describe '.favorite_opponent' do
    it 'returns opponent with lowest winning percentage against given team' do
      expect(@team_statistics.favorite_opponent('18')).to eq 'DC United'
    end
  end
  describe '.rival' do
    it 'returns opponent with highest winning percentage against given team' do
      expect(@team_statistics.rival('18')).to eq('Houston Dash').or(eq('LA Galaxy'))
    end
  end
end
