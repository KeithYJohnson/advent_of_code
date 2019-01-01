require 'rspec'
require './solution_2'

describe "count_overlaps" do
  context 'empty array' do
    subject { count_overlaps([[]]) }
    it { is_expected.to be(0) }
  end

  context 'one element greater than 1' do
    subject { count_overlaps([[2]]) }
    it { is_expected.to be(1) }
  end

  context 'no elements greater than one' do
    subject { count_overlaps([[1,1,0]]) }
    it { is_expected.to be(0) }
  end

  context 'two elements greater than one with others that arent' do
    subject { count_overlaps([[1,1,0],[2,2,1]]) }
    it { is_expected.to be(2) }
  end
end

describe "#apply_cloth" do
  let(:matrix)   { Array.new(4) { Array.new(4) { 0 } } }
  let(:expected) { Array.new(4) { Array.new(4) { 0 } } }

  context "claiming top-left square inch" do
    before { expected[0][0] = 1 }
    subject { apply_cloth(matrix, 0, 0, 1, 1) }
    it { is_expected.to eq(expected) }
  end

  context "claiming top-left square inch" do
    before { expected[0][0] = 1 }
    subject { apply_cloth(matrix, 0, 0, 1, 1) }
    it { is_expected.to eq(expected) }
  end

  context "claiming top-right square inch" do
    before { expected[0][matrix.first.length - 1] = 1 }
    subject do
      apply_cloth(
        matrix,
        matrix.first.length - 1,
        0,
        1,
        1
      )
    end
    it { is_expected.to eq(expected) }
  end
end
