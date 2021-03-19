module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validations
      @validations ||= []
    end

    def validate(attr, type, option = nil)
      validations << [attr, type, option]
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def validation_exec(attr, type, option = nil)
      var_value = instance_variable_get("@#{attr}")
      send "#{type}_validation", var_value, option
    end

    def format_validation(value, option)
      raise "Значение #{value} не соответствует формату." if !value.to_s.empty? && (value.to_s !~ option)
    end

    def presence_validation(value, _option)
      raise "Значение #{value} не может быть пустым." if value.nil? || value.to_s.empty?
    end

    def type_validation(value, option)
      raise "Для значения #{value} не задан класс для валидации." if option.nil?
      raise "Значение #{value} не совпадает с заданным классом." unless value.is_a? option
    end

    def max_length_validation(value, option)
      unless value.nil?
        raise "Значение не может быть больше #{option}." if value.size > option.to_i
      end
    end

    def min_length_validation(value, option)
      unless value.nil?
        raise "Значение не может быть меньше #{option}." if value.size < option.to_i
      end
    end

    def validate!
      self.class.validations.each { |validation| validation_exec(*validation) }
    end
  end
end
