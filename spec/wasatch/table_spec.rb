require_relative "../../lib/wasatch/table"

describe Table do
    before do
      @t1 = Table.new
      @t2 = Table.new
      @t1.numbers = [ENV['TEST_NUMBER']]
      @t2.numbers = [ENV['TEST_NUMBER']]
    end

    it "two tables == if they have the same station elements" do
      expect(@t1).to eq(@t2)
    end

    context 'tables differ' do
      before do
        @t2.stations[5].in = "151515"
      end
      it "two tables != if any element in either table is differnt" do
        expect(@t1).to_not eq(@t2)
      end

      it "sends texts to all @numbers" do
        @t1.difference(@t2)
      end
    end
end
