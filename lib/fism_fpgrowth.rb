require 'open3'

class FISMFPGrowth
  EXECUTABLE_PATH = File.expand_path('../../vendor/fpgrowth/src/fpgrowth', __FILE__)
  TARGET_TYPES = {frequent_item_sets: 's',
                  closed_item_sets: 'c',
                  maximal_item_sets: 'm',
                  frequent_generators: 'g',
                  assiciation_rules: 'r'}
  SORTING = {none: 0,
             item_frequency_ascending: 1,
             item_frequency_descending: -1,
             transaction_size_ascending: 2,
             transaction_size_descending: -2}

  FPGROWTH_VARIANTS = {simple_tree_nodes: 's',
                       complex_tree_nodes: 'c',
                       # does not support mining closed/maximal item sets:
                       top_down_single_prefix_tree: 'd',
                       # does not support the use of a k-items machine:
                       top_down_prefix_trees: 't'}

  attr_reader :transactions, :itemsets, :options

  def initialize(transactions, **options)
    @transactions = transactions
    @options = {}
    set_options(**options)
  end

  def set_options(**opts)
    @options.merge!(opts)
  end

  def call
    Open3.popen3(EXECUTABLE_PATH, *parameters, '-v ', '-', '-') do |stdin, stdout, stderr, wait_thr|
      transactions.each do |transaction|
        stdin.puts(transaction.join(' '))
      end
      stdin.close
      wait_thr.value
      @itemsets = []
      begin
        while line = stdout.readline
          @itemsets << line.split
        end
      rescue EOFError
      end
    end
    itemsets
  end

  protected

  def parameters
    params = []
    methods.select { |m| m.to_s.start_with?('build_params_') }.each do |method|
      param = send(method)
      params << param if param
    end
    params
  end

  def build_params_target_type
    if TARGET_TYPES.keys.include?(@options[:target_type])
      "-t#{TARGET_TYPES[options[:target_type]]}"
    end
  end

  def build_params_minimum_item_set_size
    build_param('m', options[:minimum_item_set_size])
  end

  def build_params_maximum_item_set_size
    build_param('n', options[:maximum_item_set_size])
  end

  def build_params_minimum_support
    letter = "s#{options[:minimum_support_type] == :absolute ? '-' : ''}"
    build_param(letter, options[:minimum_support])
  end

  def build_params_maximum_support
    letter = "S#{options[:maximum_support_type] == :absolute ? '-' : ''}"
    build_param(letter, options[:maximum_support])
  end

  def build_params_original_support_definition
    '-o' if options[:original_support_definition]
  end

  def build_params_minimum_confidence
    build_param('c', options[:minimum_confidence])
  end

  def build_params_sorting
    if SORTING.keys.include?(@options[:sorting])
      "-q#{SORTING[options[:sorting]]}"
    end
  end

  def build_params_fpgrowth_variant
    if FPGROWTH_VARIANTS.keys.include?(@options[:fpgrowth_variant])
      "-A#{FPGROWTH_VARIANTS[options[:fpgrowth_variant]]}"
    end
  end

  def build_params_prune_perfect_extensions
    '-x' if options[:prune_perfect_extensions] == false
  end

  def build_params_items_count_k_items_machine
    build_param('l', options[:items_count_k_items_machine])
  end

  def build_params_head_union_tail_pruning
    '-u' if options[:head_union_tail_pruning] == false
  end

  def build_param(letter, value)
    "-#{letter}#{value}" unless value.nil?
  end
end
