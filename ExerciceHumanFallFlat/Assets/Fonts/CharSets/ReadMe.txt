These are the lists of characters used when the fonts were last rebuilt.
They are checked in so that they can be diffed to determine if the fonts need
rebuilding. Use Sumo->CharSetExtractor from the Unity menu to extract the character
lists for the current text.

WrittenBy.txt is for the specific string on the title screen. This is set up to use
GoodDog for the first line in all languages except ru,ko,ja,zh, and GoodDog for the
second line in all languages (because it doesn't need translating). Since both lines
are a single string, I've done this using a fallback; to make it work properly,
writtenby.txt has had the colon and ru,ko,ja,zh characters removed, and the GoodDog
font falls back to MenuCJK (and Menu for Russian). I've had to change the I2Fonts.prefab
to use GoodDog for all languages, rather than overriding as MenuCJK in kojazh. Also,
there's an new version of GoodDog.ttf with the missing E-acute added.
