module ToCurrency
	TO_19 = ['zero',  'one',   'two',  'three', 'four',   'five',   'six',
	         'seven', 'eight', 'nine', 'ten',   'eleven', 'twelve', 'thirteen',
	         'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen' ]
	TENS  =  ['twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety']
  DENOM = [100, 1000, 100000, 10000000]
  OTHERS = ['thousand', 'million', 'billion',  'trillion',  'Trillion', 'Quadrillion', 'Quintrillion']

	def to_indian_currency  
    val = self.to_i
    convert_indian_currency(val) 
	end

  def to_currency
    val = self.to_i
    convert_global(val)
  end

  def to_dollars
    sign = '$'
    delimiter = ','
    value = self.to_i
    value = value.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
    "%s%.2f" % [sign, value]
  end

  def to_rupees
    sign = "\u20B9"
    delimiter = ','
    value = self.to_i
    format = "%u %n"
    value = value.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
    "%s%.2f" % [sign, value]
  end

  private

  def convert_indian_currency(val)
    return 'zero' if val == 0
    words = '';
    if (val / DENOM[3]) > 0 
      words += convert_indian_currency(val / DENOM[3]) + ' Crore '; val %= DENOM[3]; 
    end
    if (val / DENOM[2]) > 0
      words += convert_indian_currency(val / DENOM[2]) + ' Lakh '; val %= DENOM[2]; 
    end
    if (val / DENOM[1]) > 0
      words += convert_indian_currency(val / DENOM[1]) + ' Thousand '; val %= DENOM[1]; 
    end
    if (val / DENOM[0]) > 0
      words += convert_indian_currency(val / DENOM[0]) + ' Hundred '; val %= DENOM[0]; 
    end
    if val > 0       
      words += 'and ' unless words.empty?
      if val < 20
        words += TO_19[val]; 
      else 
        words += TENS[(val / 10)-2]; 
        words += '-' + TO_19[(val % 10)] if ((val % 10) > 0) 
      end
     end
     words
  end

  def convert_global(val)
    return convert_tens(val) if val < 100 
    return convert_hundreds(val) if val < 1000
    OTHERS.each_with_index do |value, index|
      position = index - 1;
      dval = 1000 ** index
      if dval > val
        mod = 1000 ** position
        l = val / mod;
        r = val - (l * mod);
        retVal = convert_hundreds(l) + ' ' + OTHERS[position-1];
        retVal = retVal + ', ' + convert_indian_currency(r) if (r > 0) 
        return retVal;
      end
    end
  end 

  def convert_tens(val)
    return TO_19[val] if (val < 20)
    TENS.each_with_index do |value, index|
    dcap = TENS[index];
    dval = 20 + 10 * index;
    if dval + 10 > val
      return dcap + '-' + TO_19[val % 10] if (val % 10) != 0
      return dcap;
    end        
    end
  end

  def convert_hundreds(val)
    d = '';
    rem = val / 100;
    mod = val % 100;
    if rem > 0
      d = TO_19[rem] + ' hundred ';
      d = d + '' if mod < 0
    end
    d = d + convert_tens(mod) if mod > 0
    return d;
  end
end

class Fixnum
  include ToCurrency
end