def fizbuzz
  (1..100).each do |n|
    if (n % 15).zero?
      puts "FizzBuzz"
    elsif (n % 3).zero?
      puts "Fizz"
    elsif (n % 5).zero?
      puts "Buzz"
    else
      puts n.to_s
    end
  end
end


# Z combinator, AKA "applicative Y-combinator"
Z = -> f { -> x { f[-> y { x[x][y] }] }
         [ -> x { f[-> y { x[x][y] }] }] }


# Integers
ZERO  = -> p { -> x {           x      }}
ONE   = -> p { -> x {         p[x]     }}
TWO   = -> p { -> x {       p[p[x]]    }}
THREE = -> p { -> x {     p[p[p[x]]]   }}
FIVE  = -> p { -> x { p[p[p[p[p[x]]]]] }}
FIFTEEN  = -> p { -> x {p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]] }}
ONE_HUNDRED = -> p { -> x { p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[p[x]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] }}

# Booleans
TRUE  = -> x { -> y { x }}
FALSE = -> x { -> y { y }}

# methods
#IF = -> p { -> t { ->f { p[t][f] }}}
IF = -> p { p }
IS_ZERO = ->n { n[ ->p { FALSE }][TRUE]}

# lists
PAIR = -> x { -> y { -> f { f[x][y] }}}
LEFT = -> p { p[ -> x { -> y { x }}]}
RIGHT = -> p { p[ -> x { -> y { y }}]}

# CONS = -> x { -> xs { PAIR[x][xs] }}
CONS = PAIR
LIST_INCREMENT = -> xs {
  CONS[
    INCREMENT[
      LEFT[ xs ]
    ]
   ][xs]
}
EMPTY = PAIR[ TRUE ][ TRUE ]


# numeric operations
INCREMENT = ->n { -> p { -> x { p[n[p][x]] }}}
ADD       = ->n { -> m { m[INCREMENT][n] }}
MULTIPLY  = ->n { -> m { m[ADD[n]][ZERO]}}
POW       = ->n { -> m { m[MULTIPLY[n]][ONE]}}

DECREMENT = -> n { LEFT[ RIGHT[ n[ LIST_INCREMENT][CONS[ZERO][EMPTY] ]]]}
SUBTRACT = ->n { -> m { m[DECREMENT][n] }}

LESS_THAN_OR_EQUAL = -> n { -> m {
  IS_ZERO[ SUBTRACT[n][m] ]
}}

DIV_ITER =
  Z[ -> div_iter {
  -> remainder { -> divisor { -> quotient {
  IF[LESS_THAN_OR_EQUAL[divisor][remainder]]
    [ ->x { div_iter[SUBTRACT[remainder][divisor]][divisor][INCREMENT[quotient]][x]}]
  #else
    [quotient]
}}}
}]

DIV = -> n { -> d { DIV_ITER[n][d][ZERO] }}

def div( n, d )
  div_iter( n, d, 0 )
end

def div_iter( n, d, i )
  if d <= n
    div_iter( n-d, d, i+1)
  else
    i
  end
end

# convenience methods to translate from lambda to Ruby
def to_integer( p )
  p[ -> n { n+ 1 }][0]
end

def to_boolean( p )
  p[true][false]
end


__END__
#lambdabuzz
def lambdabuzz
  (ONE..ONE_HUNDRED).each do |n|
    IF[(n % FIFTEEN).zero?][
      puts "FizzBuzz"
    ][IF[ (n % THREE).zero?][
      puts "Fizz"
    ][IF[ (n % FIVE).zero?][
      puts "Buzz"
    ][
      puts n.to_s
    ]]]
  end
end
