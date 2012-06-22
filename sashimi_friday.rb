module SashimiFriday
  def all?(&block)
    each do |*item|
      item = item.first if item.size == 1
      item = block.call(*item) if block
      return false unless item
    end
    return true
  end

  def any?(&block)
    each do |*item|
      item = item.first if item.size == 1
      item = block.call(*item) if block
      return true if item
    end
    return false
  end

  def none?(&block)
    each do |*item|
      item = item.first if item.size == 1
      item = block.call(*item) if block
      return false if item
    end
    return true
  end

  def one?(&block)
    result = nil
    each do |*item|
      item = item.first if item.size == 1
      item = block.call(*item) if block
      if item
        case result
        when nil
          result = true
        when true
          return false
        end
      end
    end
    return false unless result
    return result
  end

  def chunk
  end

  def collect(&block)
    return enum_for(__method__) unless block
    results = []
    each do |*item|
      item = item.first if item.size == 1
      results << block.call(*item)
    end
    return results
  end

  alias map collect

  def collect_concat
  end

  def count(*args, &block)
    found = 0
    case args.size
    when 0
      if block_given?
        each do |item|
          found += 1 if block.call(item)
        end
      else
        each do |item|
          found += 1
        end
      end
    when 1
      arg = args.first
      each do |item|
        found += 1 if item == arg
      end
    else
      raise ArgumentError
    end
    return found
  end

  def cycle(*args, &block)
    return enum_for(__method__, *args) unless block
    raise ArgumentError if args.size > 1
    n = args.first
    unless n.nil?
      begin
        n = Integer(n)
        return if n <= 0
      rescue
        raise TypeError
      end
    end
    ary = []
    each do |*item|
      item = item.first if item.size == 1
      ary << item
      block.call(item)
    end
    return if ary.empty?
    (1...(n || Float::INFINITY)).each do
      ary.each do |item|
        block.call(item)
      end
    end
    return nil
  end

  def drop(n)
    results = []
    begin
      n = Integer(n)
    rescue
      raise TypeError
    end
    raise ArgumentError if n < 0
    each do |*item|
      next if (n = n.pred) >= 0
      item = item.first if item.size == 1
      results << item
    end
    return results
  end

  def take(n)
    results = []
    begin
      n = Integer(n)
    rescue
      raise TypeError
    end
    raise ArgumentError if n < 0
    return results if n.zero?
    each do |*item|
      item = item.first if item.size == 1
      results << item
      break if (n = n.pred) <= 0
    end
    return results
  end

  def drop_while
  end

  def each_cons(n, &block)
    return enum_for(__method__, n) unless block
    n = n.to_int unless Integer === n
    raise ArgumentError unless n > 0
    list = []
    each do |*item|
      item = item.first if item.size == 1
      list.shift if list.size == n
      list.push(item)
      block.call(list.dup) if list.size == n
    end
    return nil
  end

  def each_entry(*args, &block)
    return enum_for(__method__, *args) unless block
    each(*args) do |*item|
      item = item.first if item.size == 1
      block.call(item)
    end
    return self
  end

  def each_slice(n, &block)
    return enum_for(__method__, n) unless block
    n = n.to_int unless Integer === n
    raise ArgumentError unless n > 0
    list = []
    each do |*item|
      item = item.first if item.size == 1
      list << item
      if list.size == n
        block.call(list.dup)
        list.clear
      end
    end
    block.call(list.dup) unless list.empty?
    return nil
  end

  def each_with_index(*args, &block)
    return enum_for(__method__, *args) unless block
    index = -1
    each(*args) do |*item|
      item = item.first if item.size == 1
      block.call(item, index = index.next)
    end
    return self
  end

  def each_with_object(obj, &block)
    return enum_for(__method__, obj) unless block
    each do |*item|
      item = item.first if item.size == 1
      block.call(item, obj)
    end
    return obj
  end

  def entries
    results = []
    each do |*item|
      item = item.first if item.size == 1
      results << item
    end
    return results
  end

  alias to_a entries

  def find(ifnone = nil, &block)
    return enum_for(__method__, ifnone) unless block
    each do |*item|
      item = item.first if item.size == 1
      return item if block.call(item)
    end
    ifnone.call if ifnone
  end

  alias detect find

  def find_all(&block)
    return enum_for(__method__) unless block
    results = []
    each do |*item|
      item = item.first if item.size == 1
      results << item if block.call(item)
    end
    return results
  end

  alias select find_all

  def find_index(*args, &block)
    if args.empty?
      return enum_for(__method__, *args) unless block
    else
      obj = args.first
    end
    index = 0
    each do |*item|
      item = item.first if item.size == 1
      return index if obj ? obj == item : block.call(*item)
      index += 1
    end
    return nil
  end

  def first(*args)
    unless args.empty?
      n = args.first
      n = n.to_int if n.respond_to?(:to_int)
      raise TypeError unless Numeric === n
    end
    if n
      return [] if n == 0
      raise ArgumentError if n < 0
    end
    results = []
    each do |*item|
      item = item.first if item.size == 1
      if n
        results << item
      else
        return item
      end
      n -= 1
      break if n <= 0
    end
    return results if n
  end

  def flat_map
  end

  def grep(pattern)
    result = []
    each do |item|
      if pattern === item
        result << (block_given? ? yield(item) : item)
      end
    end
    return result
  end

  def group_by(&block)
    return enum_for(__method__) unless block
    results = Hash.new{|h, k| h[k] = []}
    each do |*item|
      item = item.first if item.size == 1
      results[block.call(item)] << item
    end
    return results
  end

  def include?(val)
    each do |*item|
      item = item.first if item.size == 1
      return true if item == val
    end
    return false
  end

  alias member? include?

  def inject(*args, &block)
    block = args.pop.to_proc if Symbol === args.last
    unless args.empty?
      result = args.shift
      init = true
    end
    each do |*item|
      item = item.first if item.size == 1
      unless init
        init = true
        result = item
        next
      end
      result = block.call(result, item)
    end
    return result
  end

  alias reduce inject

  def lazy
  end

  def max
    _max = nil
    init = false
    each do |*item|
      item = item.first if item.length == 1
      unless init
        _max = item
        init = true
        next
      end

      cmp = if block_given?
              yield(item, _max)
            else
              item <=> _max
            end
      raise ArgumentError unless cmp
      _max = item if cmp > 0
    end
    _max
  end

  def max_by(&block)
    return enum_for(__method__) unless block
    max = nil
    init = false
    each do |*item|
      item = item.first if item.size == 1
      value = block.call(item)
      unless init
        max = [value, item]
        init = true
        next
      end
      cmp = value <=> max[0]
      raise ArgumentError unless cmp
      max = [value, item] if cmp > 0
    end
    return max && max[1]
  end

  def min(&block)
    min = nil
    init = false
    each do |*item|
      item = item.first if item.size == 1
      unless init
        min = item
        init = true
        next
      end
      cmp = if block
              block.call(item, min)
            else
              item <=> min
            end
      raise ArgumentError unless cmp
      min = item if cmp < 0
    end
    return min
  end

  def min_by(&block)
    return enum_for(__method__) unless block
    min = nil
    init = false
    each do |*item|
      item = item.first if item.size == 1
      value = block.call(item)
      unless init
        min = [value, item]
        init = true
        next
      end
      cmp = value <=> min[0]
      raise ArgumentError unless cmp
      min = [value, item] if cmp < 0
    end
    return min && min[1]
  end

  def minmax(&block)
    minmax = [nil, nil]
    init = false
    each do |*item|
      item = item.first if item.size == 1
      unless init
        minmax = [item, item]
        init = true
        next
      end
      {0 => :<, 1 => :>}.each do |pos, op|
        cmp = if block
                block.call(item, minmax[pos])
              else
                item <=> minmax[pos]
              end
        raise ArgumentError unless cmp
        minmax[pos] = item if cmp.__send__(op, 0)
      end
    end
    return minmax
  end

  def minmax_by(&block)
    return enum_for(__method__) unless block
    minmax = [[nil, nil], [nil, nil]]
    init = false
    each do |*item|
      item = item.first if item.size == 1
      value = block.call(item)
      unless init
        minmax = [[value, item], [value, item]]
        init = true
        next
      end
      {0 => :<, 1 => :>}.each do |pos, op|
        cmp = value <=> minmax[pos][0]
        raise ArgumentError unless cmp
        minmax[pos] = [value, item] if cmp.__send__(op, 0)
      end
    end
    return minmax.map(&:last)
  end

  def partition(&block)
    return enum_for(__method__) unless block
    ts, fs = [], []
    each do |*item|
      item = item.first if item.size == 1
      (block.call(item) ? ts : fs) << item
    end
    return ts, fs
  end

  def reject(&block)
    return enum_for(__method__) unless block
    results = []
    each do |*item|
      item = item.first if item.size == 1
      results << item unless block.call(item)
    end
    return results
  end

  def reverse_each(&block)
    return enum_for(__method__) unless block
    items = []
    each do |*item|
      item = item.first if item.size == 1
      items << item
    end
    until items.empty?
      block.call(items.pop)
    end
    return self
  end

  def slice_before(*args, &block)
    if block
      raise ArgumentError unless args.size < 2
      initial_state = args.first
      initial_state = initial_state.dup unless initial_state.nil?
    else
      raise ArgumentError unless args.size == 1
      pattern = args.first
    end
    results = []
    each do |*item|
      item = item.first if item.size == 1
      state = if block
                args = [item]
                args << initial_state unless initial_state.nil?
                state = block.call(*args)
              else
                pattern === item
              end
      results << [] if state
      last = results.last
      last ? last << item : results << [item]
    end
    return results.to_enum(:each)
  end

  def sort
  end

  def sort_by
  end

  def take_while(&block)
    return enum_for(__method__) unless block
    results = []
    each do |*item|
      item = item.first if item.size == 1
      break unless block.call(item)
      results << item
    end
    return results
  end

  def zip(*lists, &block)
    results = []
    lists = lists.map do |list|
      list = list.to_ary if list.respond_to?(:to_ary)
      list.to_enum(:each)
    end
    each do |*item|
      item = item.first if item.size == 1
      items = [item]
      lists.each do |list|
        items << (list.next rescue nil)
      end
      if block
        block.call(items)
      else
        results << items
      end
    end
    return results unless block
  end
end
