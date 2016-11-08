class Matches
  def initialize(lt)
    @list_of_matches = []
    @league_table = lt
  end

  def push(match)
    if valid?(match)
      @list_of_matches.push match
      @league_table.push_result parse(match)
    end
  end

  private

  def valid?(match)
    match =~ /\A\S+\D+\s*\d{1,2}\s*-{1}\s*\d{1,2}\s*\D+\S+\z/
  end

  def parse(match)
    team1 = match.scan(/\A\D+\s*/).first.squeeze(' ').strip.downcase
    score1 = scores_for(match).first

    team2 = match.scan(/\s\D+$/).first.squeeze(' ').strip.downcase
    score2 = scores_for(match).last

    [team1, score1, team2, score2]
  end

  def scores_for(match)
    match.to_enum(:scan, /\d+/).map { Regexp.last_match.to_s.to_i }
  end
end
