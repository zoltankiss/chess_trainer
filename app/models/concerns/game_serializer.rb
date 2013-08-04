class GameSerializer
  class << self
    def serialize(arr)
      arr.map { |k| k.join(',') }.join('|')
    end

    def de_serialize(str)
      str.split('|').map { |k| k.split(',') }
    end
  end
end
