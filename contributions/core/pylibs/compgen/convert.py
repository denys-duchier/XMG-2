import xmg.compgen.Tokenizer, xmg.compgen.BrickTokenizer
from xmg.compgen.user_parser import semicolon,colon,pipe,arrow,endsection,_id,sqstring,T,NT,EXT
from xmg.compgen.Symbol import EOF

def convertEOF(token) : 
    return EOF,None,token.coord

opt={
    ";":semicolon,
    ":":colon,
    "|":pipe,
    "->":arrow,
    "%%":endsection,
    }

def convertOperator(token) :
    return opt[token.name],None,token.coord

def convertFloat (token) :
    return T("float"),token.value,token.coord

def convertInt (token) :
    return T("int"),token.value,token.coord

def convertSingleQuotedString (token) :
    return sqstring,token.text,token.coord

def convertDoubleQuotedString (token) :
    return T("string"),token.text,token.coord

def convertIdentifier (token) :
    return _id,token.name,token.coord

def convertKeyword (token) : 
    return T("keyword"),token.name,token.coord

kopt={
    "%token":T,
    "%type":NT,
    "%ext":EXT
    }

def convertPercentKeyword (token) : 
    return kopt[token.name],None,token.coord

TABLE={
    xmg.compgen.Tokenizer.TokenEOF:convertEOF,
    xmg.compgen.Tokenizer.TokenOperator:convertOperator,
    xmg.compgen.Tokenizer.TokenFloat:convertFloat,
    xmg.compgen.Tokenizer.TokenInt:convertInt,
    xmg.compgen.Tokenizer.TokenSingleQuotedString:convertSingleQuotedString,
    xmg.compgen.Tokenizer.TokenDoubleQuotedString:convertDoubleQuotedString,
    xmg.compgen.Tokenizer.TokenIdentifier:convertIdentifier,
    xmg.compgen.Tokenizer.TokenKeyword:convertKeyword,
    xmg.compgen.BrickTokenizer.TokenPercentKeyword:convertPercentKeyword,
    }

def convert(token):
    return TABLE[type(token)](token)