require 'spec_helper'

describe FISMFPGrowth do
  let(:transactions) do
    [[3, 6, 1],
     [1],
     [6, 2, 1],
     [6, 7, 1],
     [4, 6, 1],
     [3, 4, 1],
     [3, 5, 1]]
  end
  let(:fpgrowth) { FISMFPGrowth.new(transactions) }

  context 'with default options' do
    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['6', '1'],
                        ['6'],
                        ['3', '6', '1'],
                        ['3', '6'],
                        ['3', '1'],
                        ['3'],
                        ['4', '3', '1'],
                        ['4', '3'],
                        ['4', '6', '1'],
                        ['4', '6'],
                        ['4', '1'],
                        ['4'],
                        ['2', '1', '6'],
                        ['2', '1'],
                        ['2', '6'],
                        ['2'],
                        ['7', '1', '6'],
                        ['7', '1'],
                        ['7', '6'],
                        ['7'],
                        ['5', '1', '3'],
                        ['5', '1'],
                        ['5', '3'],
                        ['5'],
                        ['1']])
    end
  end

  context 'frequent item sets' do
    before { fpgrowth.set_options(target_type: :frequent_item_sets) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['6', '1'],
                        ['6'],
                        ['3', '6', '1'],
                        ['3', '6'],
                        ['3', '1'],
                        ['3'],
                        ['4', '3', '1'],
                        ['4', '3'],
                        ['4', '6', '1'],
                        ['4', '6'],
                        ['4', '1'],
                        ['4'],
                        ['2', '1', '6'],
                        ['2', '1'],
                        ['2', '6'],
                        ['2'],
                        ['7', '1', '6'],
                        ['7', '1'],
                        ['7', '6'],
                        ['7'],
                        ['5', '1', '3'],
                        ['5', '1'],
                        ['5', '3'],
                        ['5'],
                        ['1']])
    end
  end

  context 'closed item sets' do
    before { fpgrowth.set_options(target_type: :closed_item_sets) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['5', '1', '3'],
                        ['7', '1', '6'],
                        ['2', '1', '6'],
                        ['4', '3', '1'],
                        ['4', '6', '1'],
                        ['4', '1'],
                        ['3', '6', '1'],
                        ['3', '1'],
                        ['6', '1'],
                        ['1']])
    end
  end

  context 'maximal item sets' do
    before { fpgrowth.set_options(target_type: :maximal_item_sets) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['5', '1', '3'],
                        ['7', '1', '6'],
                        ['2', '1', '6'],
                        ['4', '3', '1'],
                        ['4', '6', '1'],
                        ['3', '6', '1']])
    end
  end

  context 'frequent_generators' do
    before { fpgrowth.set_options(target_type: :frequent_generators) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['6'],
                        ['3', '6'],
                        ['3'],
                        ['4', '3'],
                        ['4', '6'],
                        ['4'],
                        ['2'],
                        ['7'],
                        ['5']])
    end
  end

  context 'association rules' do
    before { fpgrowth.set_options(target_type: :association_rules) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['6', '1'],
                        ['6'],
                        ['3', '6', '1'],
                        ['3', '6'],
                        ['3', '1'],
                        ['3'],
                        ['4', '3', '1'],
                        ['4', '3'],
                        ['4', '6', '1'],
                        ['4', '6'],
                        ['4', '1'],
                        ['4'],
                        ['2', '1', '6'],
                        ['2', '1'],
                        ['2', '6'],
                        ['2'],
                        ['7', '1', '6'],
                        ['7', '1'],
                        ['7', '6'],
                        ['7'],
                        ['5', '1', '3'],
                        ['5', '1'],
                        ['5', '3'],
                        ['5'],
                        ['1']])
    end
  end

  context 'minimum item set size increased' do
    before { fpgrowth.set_options(minimum_item_set_size: 3) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['3', '6', '1'],
                        ['4', '3', '1'],
                        ['4', '6', '1'],
                        ['2', '6', '1'],
                        ['7', '6', '1'],
                        ['5', '3', '1']])
    end
  end

  context 'maximum item set size decreased' do
    before { fpgrowth.set_options(maximum_item_set_size: 1) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['1'], ['2'], ['3'], ['4'], ['5'], ['6'], ['7']])
    end
  end

  context 'minimum_support increased to 50%' do
    before { fpgrowth.set_options(minimum_support: 50) }

    it 'return the correct result' do
      expect(fpgrowth.call).to match_array([['1'], ['6'], ['6', '1']])
    end
  end

  context 'maximum_support decreased to 15%' do
    before { fpgrowth.set_options(maximum_support: 15) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['2'],
                        ['2', '1'],
                        ['2', '1', '6'],
                        ['2', '6'],
                        ['3', '6'],
                        ['3', '6', '1'],
                        ['4', '3'],
                        ['4', '3', '1'],
                        ['4', '6'],
                        ['4', '6', '1'],
                        ['5'],
                        ['5', '1'],
                        ['5', '1', '3'],
                        ['5', '3'],
                        ['7'],
                        ['7', '1'],
                        ['7', '1', '6'],
                        ['7', '6']])
    end
  end

  context 'minimum absolute support increased' do
    before { fpgrowth.set_options(minimum_support_type: :absolute, minimum_support: 3) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['1'], ['3'], ['3', '1'], ['6'], ['6', '1']])
    end
  end

  context 'maximum absolute support increased' do
    before { fpgrowth.set_options(maximum_support_type: :absolute, maximum_support: 1) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['2'],
                        ['2', '1'],
                        ['2', '1', '6'],
                        ['2', '6'],
                        ['3', '6'],
                        ['3', '6', '1'],
                        ['4', '3'],
                        ['4', '3', '1'],
                        ['4', '6'],
                        ['4', '6', '1'],
                        ['5'],
                        ['5', '1'],
                        ['5', '1', '3'],
                        ['5', '3'],
                        ['7'],
                        ['7', '1'],
                        ['7', '1', '6'],
                        ['7', '6']])
    end
  end

  context 'original suport definition' do
    before { fpgrowth.set_options(original_support_definition: true) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['1'],
                        ['2'],
                        ['2', '1'],
                        ['2', '1', '6'],
                        ['2', '6'],
                        ['3'],
                        ['3', '1'],
                        ['3', '6'],
                        ['3', '6', '1'],
                        ['4'],
                        ['4', '1'],
                        ['4', '3'],
                        ['4', '3', '1'],
                        ['4', '6'],
                        ['4', '6', '1'],
                        ['5'],
                        ['5', '1'],
                        ['5', '1', '3'],
                        ['5', '3'],
                        ['6'],
                        ['6', '1'],
                        ['7'],
                        ['7', '1'],
                        ['7', '1', '6'],
                        ['7', '6']])
    end
  end

  context 'minimum confidence increased' do
    before { fpgrowth.set_options(minimum_confidence: 100) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['1'],
                        ['2'],
                        ['2', '1'],
                        ['2', '1', '6'],
                        ['2', '6'],
                        ['3'],
                        ['3', '1'],
                        ['3', '6'],
                        ['3', '6', '1'],
                        ['4'],
                        ['4', '1'],
                        ['4', '3'],
                        ['4', '3', '1'],
                        ['4', '6'],
                        ['4', '6', '1'],
                        ['5'],
                        ['5', '1'],
                        ['5', '1', '3'],
                        ['5', '3'],
                        ['6'],
                        ['6', '1'],
                        ['7'],
                        ['7', '1'],
                        ['7', '1', '6'],
                        ['7', '6']])
    end
  end

  context 'sorting: none' do
    before { fpgrowth.set_options(sorting: :none) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to eq([['3', '1'],
               ['3'],
               ['6', '3', '1'],
               ['6', '3'],
               ['6', '1'],
               ['6'],
               ['2', '1', '6'],
               ['2', '1'],
               ['2', '6'],
               ['2'],
               ['7', '1', '6'],
               ['7', '1'],
               ['7', '6'],
               ['7'],
               ['4', '6', '1'],
               ['4', '6'],
               ['4', '3', '1'],
               ['4', '3'],
               ['4', '1'],
               ['4'],
               ['5', '1', '3'],
               ['5', '1'],
               ['5', '3'],
               ['5'],
               ['1']])
    end
  end

  context 'sorting: item frequency ascending' do
    before { fpgrowth.set_options(sorting: :item_frequency_ascending) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['1'],
                        ['2'],
                        ['2', '1'],
                        ['2', '1', '6'],
                        ['2', '6'],
                        ['3'],
                        ['3', '1'],
                        ['3', '6'],
                        ['3', '6', '1'],
                        ['4'],
                        ['4', '1'],
                        ['4', '3'],
                        ['4', '3', '1'],
                        ['4', '6'],
                        ['4', '6', '1'],
                        ['5'],
                        ['5', '1'],
                        ['5', '1', '3'],
                        ['5', '3'],
                        ['6'],
                        ['6', '1'],
                        ['7'],
                        ['7', '1'],
                        ['7', '1', '6'],
                        ['7', '6']])
    end
  end

  context 'sorting: item frequency descending' do
    before { fpgrowth.set_options(sorting: :item_frequency_descending) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to eq([['2', '1'],
               ['2'],
               ['7', '1'],
               ['7'],
               ['5', '1'],
               ['5'],
               ['4', '1'],
               ['4'],
               ['3', '4', '1'],
               ['3', '4'],
               ['3', '5', '1'],
               ['3', '5'],
               ['3', '1'],
               ['3'],
               ['6', '3', '1'],
               ['6', '3'],
               ['6', '4', '1'],
               ['6', '4'],
               ['6', '7', '1'],
               ['6', '7'],
               ['6', '2', '1'],
               ['6', '2'],
               ['6', '1'],
               ['6'],
               ['1']])
    end
  end

  context 'sorting: item frequency descending' do
    before { fpgrowth.set_options(sorting: :transaction_size_ascending) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to eq([['6', '1'],
               ['6'],
               ['3', '6', '1'],
               ['3', '6'],
               ['3', '1'],
               ['3'],
               ['4', '3', '1'],
               ['4', '3'],
               ['4', '6', '1'],
               ['4', '6'],
               ['4', '1'],
               ['4'],
               ['2', '1', '6'],
               ['2', '1'],
               ['2', '6'],
               ['2'],
               ['7', '1', '6'],
               ['7', '1'],
               ['7', '6'],
               ['7'],
               ['5', '1', '3'],
               ['5', '1'],
               ['5', '3'],
               ['5'],
               ['1']])
    end
  end

  context 'sorting: item frequency descending' do
    before { fpgrowth.set_options(sorting: :transaction_size_descending) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to eq([['2', '1'],
               ['2'],
               ['7', '1'],
               ['7'],
               ['5', '1'],
               ['5'],
               ['4', '1'],
               ['4'],
               ['3', '4', '1'],
               ['3', '4'],
               ['3', '5', '1'],
               ['3', '5'],
               ['3', '1'],
               ['3'],
               ['6', '3', '1'],
               ['6', '3'],
               ['6', '4', '1'],
               ['6', '4'],
               ['6', '7', '1'],
               ['6', '7'],
               ['6', '2', '1'],
               ['6', '2'],
               ['6', '1'],
               ['6'],
               ['1']])
    end
  end

  context 'fpgrowth variant: simple tree nodes' do
    before { fpgrowth.set_options(fpgrowth_variant: :simple_tree_nodes) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to eq([['6', '1'],
               ['6'],
               ['3', '6', '1'],
               ['3', '6'],
               ['3', '1'],
               ['3'],
               ['4', '6', '1'],
               ['4', '6'],
               ['4', '3', '1'],
               ['4', '3'],
               ['4', '1'],
               ['4'],
               ['2', '1', '6'],
               ['2', '1'],
               ['2', '6'],
               ['2'],
               ['7', '1', '6'],
               ['7', '1'],
               ['7', '6'],
               ['7'],
               ['5', '1', '3'],
               ['5', '1'],
               ['5', '3'],
               ['5'],
               ['1']])
    end
  end

  context 'fpgrowth variant: complex tree nodes' do
    before { fpgrowth.set_options(fpgrowth_variant: :complex_tree_nodes) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to eq([['6', '1'],
               ['6'],
               ['3', '6', '1'],
               ['3', '6'],
               ['3', '1'],
               ['3'],
               ['4', '3', '1'],
               ['4', '3'],
               ['4', '6', '1'],
               ['4', '6'],
               ['4', '1'],
               ['4'],
               ['2', '1', '6'],
               ['2', '1'],
               ['2', '6'],
               ['2'],
               ['7', '1', '6'],
               ['7', '1'],
               ['7', '6'],
               ['7'],
               ['5', '1', '3'],
               ['5', '1'],
               ['5', '3'],
               ['5'],
               ['1']])
    end
  end

  context 'fpgrowth variant: top down single prefix tree' do
    before { fpgrowth.set_options(fpgrowth_variant: :top_down_single_prefix_tree) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to eq([['6', '1'],
               ['6'],
               ['3', '6', '1'],
               ['3', '6'],
               ['3', '1'],
               ['3'],
               ['4', '6', '1'],
               ['4', '6'],
               ['4', '3', '1'],
               ['4', '3'],
               ['4', '1'],
               ['4'],
               ['2', '1', '6'],
               ['2', '1'],
               ['2', '6'],
               ['2'],
               ['7', '1', '6'],
               ['7', '1'],
               ['7', '6'],
               ['7'],
               ['5', '1', '3'],
               ['5', '1'],
               ['5', '3'],
               ['5'],
               ['1']])
    end
  end

  context 'fpgrowth variant: top down prefix trees' do
    before { fpgrowth.set_options(fpgrowth_variant: :top_down_prefix_trees) }

    it 'return the correct result' do
      expect(fpgrowth.call).to eq([])
    end
  end

  context 'prune perfect extensions deactivated' do
    before { fpgrowth.set_options(prune_perfect_extensions: false) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['1'],
                        ['2'],
                        ['2', '1'],
                        ['2', '6'],
                        ['2', '6', '1'],
                        ['3'],
                        ['3', '1'],
                        ['3', '6'],
                        ['3', '6', '1'],
                        ['4'],
                        ['4', '1'],
                        ['4', '3'],
                        ['4', '3', '1'],
                        ['4', '6'],
                        ['4', '6', '1'],
                        ['5'],
                        ['5', '1'],
                        ['5', '3'],
                        ['5', '3', '1'],
                        ['6'],
                        ['6', '1'],
                        ['7'],
                        ['7', '1'],
                        ['7', '6'],
                        ['7', '6', '1']])
    end
  end

  context 'items count for k items machine increased' do
    before { fpgrowth.set_options(items_count_k_items_machine: 64) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['1'],
                        ['2'],
                        ['2', '1'],
                        ['2', '1', '6'],
                        ['2', '6'],
                        ['3'],
                        ['3', '1'],
                        ['3', '6'],
                        ['3', '6', '1'],
                        ['4'],
                        ['4', '1'],
                        ['4', '3'],
                        ['4', '3', '1'],
                        ['4', '6'],
                        ['4', '6', '1'],
                        ['5'],
                        ['5', '1'],
                        ['5', '1', '3'],
                        ['5', '3'],
                        ['6'],
                        ['6', '1'],
                        ['7'],
                        ['7', '1'],
                        ['7', '1', '6'],
                        ['7', '6']])
    end
  end

  context 'head union tail pruning deactivated' do
    before { fpgrowth.set_options(head_union_tail_pruning: false) }

    it 'return the correct result' do
      expect(fpgrowth.call).
        to match_array([['1'],
                        ['2'],
                        ['2', '1'],
                        ['2', '1', '6'],
                        ['2', '6'],
                        ['3'],
                        ['3', '1'],
                        ['3', '6'],
                        ['3', '6', '1'],
                        ['4'],
                        ['4', '1'],
                        ['4', '3'],
                        ['4', '3', '1'],
                        ['4', '6'],
                        ['4', '6', '1'],
                        ['5'],
                        ['5', '1'],
                        ['5', '1', '3'],
                        ['5', '3'],
                        ['6'],
                        ['6', '1'],
                        ['7'],
                        ['7', '1'],
                        ['7', '1', '6'],
                        ['7', '6']])
    end
  end
end
