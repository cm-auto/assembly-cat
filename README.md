# assembly-cat

A program that does basic operations of Unix' `cat` command.

Print out a single file:
```bash
>cat test.txt
Content of test.txt
```

Concatenate multiple files (no character between contents of file):
```bash
>cat test.txt hello.md
Content of test.txtContent of hello.md
```

Or omit arguments to read from stdin:
```bash
>cat
>Hello World
Hello World
```