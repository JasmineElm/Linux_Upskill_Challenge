# Day 6 - Vim

Full Disclosure, I love Vim.  As I mentioned yesterday, Vim gives loads of useful power, though there's a learning curve there.  Perhaps "learning curve" is a little misleading.  It's one thing to learn Vim, quite another to _understand_.  There's an infamous post on Stack Overflow that [demonstrates this difference perfectly](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim/1220118#1220118).  You can learn how to use Vi and be perfectly productive.  Alternatively, you can learn the _grammar_ of vim and achieve complex edits with a few key strokes.  

From reading various posts on Stack Overflow, Reddit and so on, it looks like a lot of people have a 'lightbulb moment' on the way to _grok-ing vim_.  Mine was learning `ciw`.  I remember it through the mnemonic **c**hange **i**nner **w**ord. it will delete word surrounding the cursor _and_ place you in insert mode. That tip and a whole bunch of others are in [this talk](https://www.youtube.com/watch?v=wlR5gYd6um0); well worth half an hour of your time.  

Another favourite trick is to combine action and motion.  This can be things like `yank`-ing everything to the end of the line (`y$`), yanking 5 line (`5yy`), deleting a paragraph (`d]`), or completely deleting the contents of a file (`ggdG`).

On top of the grammar of vim is a whole ecosystem of plugins and scripts that can really elevate your usage; it is wholly possible to personalise your vim installation to matc your needs, whether you are a [novelist](https://www.naperwrimo.org/wiki/index.php?title=Vim_for_Writers), a [Java programmer](https://spacevim.org/use-vim-as-a-java-ide/) or anything in between.  Whilst I have a [fairly heavily modified vim](https://github.com/JasmineElm/vim), the vim I use on servers is _totally_ vanilla.  This is for a quite simple reason: colleagues using the server need to be able to use core tools like vim without wrestling with unfamiliar config.