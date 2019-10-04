require "spec_helper"

describe StatsLite::Default do
  keys = %w(host cpu ram hdd)

  keys.each do |key|
    describe key do
      values = described_class.send(key)

      values.each do |value|
        context value[0] do
          it "present" do
            expect(value[1]).not_to eq ""
          end
        end
      end
    end
  end
end