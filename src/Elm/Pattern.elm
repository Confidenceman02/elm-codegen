module Elm.Pattern exposing (..)


{-|


Patterns for unpacking various values.

    AllPattern: _
    UnitPattern: ()
    CharPattern: 'c'
    StringPattern: "hello"
    IntPattern: 42
    HexPattern: 0x11
    FloatPattern: 42.0
    TuplePattern: (a, b)
    RecordPattern: {name, age}
    UnConsPattern: x :: xs
    ListPattern: [ x, y ]
    VarPattern: x
    NamedPattern: Just _
    AsPattern: _ as x
    ParenthesizedPattern: ( _ )

-}

import Elm.Syntax.Declaration  as Declaration exposing (Declaration(..))

import Elm.Syntax.Pattern as Pattern
import Internal.Util as Util
import Elm


type alias Pattern =
    Pattern.Pattern



{-| 
-}
all : Pattern
all =
    Pattern.AllPattern


{-| 
-}
unit : Pattern
unit =
    Pattern.UnitPattern


{-| 
-}
char : Char -> Pattern
char charVal =
    Pattern.CharPattern charVal


{-| 
-}
string : String -> Pattern
string literal =
    Pattern.StringPattern literal


{-| 
-}
int : Int -> Pattern
int intVal =
    Pattern.IntPattern intVal


{-| 
-}
hex : Int -> Pattern
hex hexVal =
    Pattern.HexPattern hexVal


{-| 
-}
float : Float -> Pattern
float floatVal =
    Pattern.FloatPattern floatVal


{-| 
-}
tuple : Pattern -> Pattern -> Pattern
tuple one two =
    Pattern.TuplePattern (Util.nodifyAll [one ,two])



{-| 
-}
triple : Pattern -> Pattern -> Pattern
triple one two =
    Pattern.TuplePattern (Util.nodifyAll [one ,two])



{-| RecordPattern (List (Node String))
-}
fields : List String -> Pattern
fields flds =
    Pattern.RecordPattern (Util.nodifyAll flds)


{-| 
-}
cons : Pattern -> Pattern -> Pattern
cons hd tl =
    Pattern.UnConsPattern (Util.nodify hd) (Util.nodify tl)


{-| ListPattern (List (Node Pattern))
-}
list : List Pattern -> Pattern
list seq =
    Pattern.ListPattern (Util.nodifyAll seq)


{-| VarPattern String
-}
var : String -> Pattern
var name =
    Pattern.VarPattern name


{-| 

        Elm.Pattern.named "Just" [ Elm.Pattern.var "value" ]

    would result in the following unpacking

        (Just value)

-}
named : String -> List Pattern -> Pattern
named name patterns =
    Pattern.NamedPattern { moduleName = [], name = name } (Util.nodifyAll patterns)


{-| 
-}
namedFrom : Elm.Module -> String -> List Pattern -> Pattern
namedFrom moduleName name patterns =
    Pattern.NamedPattern { moduleName = Util.unpack moduleName, name = name } (Util.nodifyAll patterns)


{-| 
-}
withAlias :  String -> Pattern -> Pattern
withAlias name pattern  =
    Pattern.AsPattern (Util.nodify pattern) (Util.nodify name)


{-| ParenthesizedPattern (Node Pattern)
-}
parens : Pattern -> Pattern
parens pattern =
    Pattern.ParenthesizedPattern (Util.nodify pattern)