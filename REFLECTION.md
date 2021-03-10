# Reflection

**Which utility did you select?**
- Flex (lex)
- Bison (yacc)
- C

**Why did you choose that utility? What were some useful resources to learn how to use that program?**
- Flex and bison had heavy documentation which promoted ease of use, and had backwards-compatibility with lex and yacc, along with additional features.
    - [Flex Documentation](http://dinosaur.compilertools.net/lex/index.html)
    - [GNU Bison Documentation](https://www.gnu.org/software/bison/manual/bison.html)
    - Lex & Yacc (2nd ed) - Levine et al
- Many online tutorials focus on lex and yacc as the de facto lexer and parser to go with. Other tutorials that went with C++ or Java as the language of choice for implementing lexers and parsers were not as organized and didn't seem to follow any standard conventions. Since lex and yacc allow for auxiliary C code, that was the language I chose to stick with.
    - [Part 01: Tutorial on lex/yacc](https://www.youtube.com/watch?v=54bo1qaHAfk)
    - [Part 02: Tutorial on lex/yacc](https://www.youtube.com/watch?v=__-wUHG2rfM)
    - [Create Programming Language #2](https://www.youtube.com/watch?v=gpmBEx_Cg8k)

**Was there any difficulty or ease with using the terminal environment?**
- Not at all. I have been accustomed to using Git and GNU Make within Linux environments, so the terminal is familiar territory.

**What kind of language are you designing?**
- In the early stages of development, I've decided to keep it simple and focus on making a mathematical and logical imperative language with syntax similar to Python.
- This may change in the future as I learn how to implement an abstract syntax tree and implement more complex grammar rules (functions, OOP features)
    - [Parser and Lexer - How to Create a Compiler part 1/5](https://www.youtube.com/watch?v=eF9qWbuQLuw)