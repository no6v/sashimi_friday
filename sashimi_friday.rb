module SashimiFriday
  def all?
    each do |item|
      return false unless block_given? ? yield(item) : item
    end
    return true
  end

  def any?
    each do |item|
      return true if block_given? ? yield(item) : item
    end
    return false
  end

  def none?
    each do |item|
      return false if block_given? ? yield(item) : item
    end
    return true
  end

  def one?
    result = nil
    each do |item|
      if block_given? ? yield(item) : item
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

  def collect
  end

  def collect_concat
  end

  def count(*args)
    found = 0
    case args.size
    when 0
      if block_given?
        each do |item|
          found += 1 if yield(item)
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

  def cycle
  end

  def detect
  end

  def drop
  end

  def drop_while
  end

  def each_cons
  end

  def each_entry
  end

  def each_slice
  end

  def each_with_index
  end

  def each_with_object
  end

  def entries
  end

  def find
  end

  def find_all
  end

  def find_index
  end

  def first
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

  def group_by
  end

  def include?
  end

  def inject
  end

  def lazy
  end

  def map
  end

  def max
  end

  def max_by
  end

  def member?
  end

  def min
  end

  def min_by
  end

  def minmax
  end

  def minmax_by
  end

  def partition
  end

  def reduce
  end

  def reject
  end

  def reverse_each
  end

  def select
  end

  def slice_before
  end

  def sort
  end

  def sort_by
  end

  def take
  end

  def take_while
  end

  def to_a
  end

  def zip
  end
end
