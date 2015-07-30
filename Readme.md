This gem provides a ruby wrapper for [Christian Borgelt's FP-Growth implementation](http://borgelt.net/fpgrowth.html).

# Requirements

To build this gem, both, `gcc` and `bash` must be installed on the system.
This also means that it's not possible to use it on vanilla Windows systems.

# Installation

    gem install fism-fpgrowth

# Usage

A simple usage example:
```ruby
require 'fism_fpgrowth'
f = FISMFPGrowth.new([[413, 416, 420], [420], [416, 419, 420], [416, 417, 420], [414, 416, 420], [413, 414, 420], [413, 415, 420]], target_type: :maximal_item_sets, minimum_support: 1, minimum_support_type: :absolute)
f.call
=> [["415", "420", "413"], ["417", "420", "416"], ["419", "420", "416"], ["414", "413", "420"], ["414", "416", "420"], ["413", "416", "420"]]
```

You can also change the options after initialization:
```ruby
require 'fism_fpgrowth'
f = FISMFPGrowth.new([[413, 416, 420], [420], [416, 419, 420], [416, 417, 420], [414, 416, 420], [413, 414, 420], [413, 415, 420]], target_type: :maximal_item_sets, , minimum_support_type: :relative)
f.set_options(minimum_support: 1, minimum_support: :absolute)
f.call
=> [["415", "420", "413"], ["417", "420", "416"], ["419", "420", "416"], ["414", "413", "420"], ["414", "416", "420"], ["413", "416", "420"]]
```

# Options

The following options are recognised:

* `:target_type` - possible values:
  * `:frequent_item_sets` (default)
  * `:closed_item_sets`
  * `:maximal_item_sets`
  * `:frequent_generators`
  * `:assiciation_rules`
* `:minimum_item_set_size` (non-negative integer, default: 1)
* `:maximum_item_set_size` (non-negative integer, default: unlimited)
* `:minimum_support` (non-negative number, default: 10)
* `:maximum_support` (non-negative number, default: 100)
* `:minimum_support_type` - possible values:
  * `:relative` (default - then the value is a percentage, i.e. 0-100)
  * `:absolute`
* `:maximum_support_type` - possible values:
  * `:relative` (default - then the value is a percentage, i.e. 0-100)
  * `:absolute`
* `:original_support_definition` (boolean, default: false) use original definition of the support of a rule (body & head)
* `:minimum_confidence` (number, 0-100, default: 80) minimum confidence of a rule as a percentage
* `:sorting` - possible values:
  * `:none` (default)
  * `:item_frequency_ascending`
  * `:item_frequency_descending`
  * `:transaction_size_ascending`
  * `:transaction_size_descending`
* `:fpgrowth_variant` - possible values:
  * `:simple_tree_nodes` simple tree nodes with only successor and parent
  * `:complex_tree_nodes` complex tree nodes with children and siblings (supports item reordering w.r.t. conditional support, but closed/maximal item sets can only be mined without reordering)
  * `:top_down_single_prefix_tree` top-down processing on a single prefix tree (does not support mining closed/maximal item sets)
  * `:top_down_prefix_trees` top-down processing of the prefix trees (does not support the use of a k-items machine)
* `:prune_perfect_extensions` (boolean, default: true)
* `:items_count_k_items_machine` number of items for k-items machine
* `:head_union_tail_pruning` use head union tail (hut) pruning (boolean, default: true)

# Limitations

It is not allowed to use any items that have spaces in their string representation.
Otherwise those items can't be separated correctly when the item set array is built.

# How it works

The gem actually does almost no computation.
It calls Borgelt's application via `Open3.popen3`, passes the transactions array to it, and returns an item set array.
This wrapper only allows the usage with ruby arrays instead of plain strings.

# Use case

This gem is supposed to work with the [Ontohub](https://github.com/ontohub/ontohub) web application.
For ontohub, we only use integers as items. The limitations don't apply there.
I don't intend to make this gem comatible with other applications.
It is only used to abstract from the binary compiled during the gem installation.
