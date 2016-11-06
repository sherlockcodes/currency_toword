# currency_toword

gem file to convert currency in number to currency in word format.

it also supports indian currency format.

https://rubygems.org/gems/currency_toword 

to install this gemfile,

gem install currency_toword

how to use?

require 'currency_toword'

2323454.to_currency # "two million, three Lakh twenty-three Thousand four Hundred and fifty-four"

2323454.to_indian_currency # "twenty-three Lakh twenty-three Thousand four Hundred and fifty-four"

3454.to_rupees # "₹3,454"

3454.to_dollars # "$3,454"
