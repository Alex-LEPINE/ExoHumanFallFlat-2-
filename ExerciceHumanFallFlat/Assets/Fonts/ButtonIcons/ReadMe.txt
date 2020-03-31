This source font (Blogger Sans-Bold.ttf) is rescued from the original 1.2 PS4 branch. It is a copy of standard
"Blogger Sans-Bold" but WITH BUTTON ICON GLYPHS ADDED!! The glyphs are at code points 20bb..211f. That branch
generated font tpages with the button icons embedded, but that caused a big problem when bringing in PC 1.4,
which had new fonts and retired some old ones.

So my new solution is to create a fallback font (ButtonIconsSDF) with just the button icons in. Then the other
font assets can be copied straight from the PC (or rebuilt locally), and they just need a fallback ref to
ButtonIcons SDF to make them work again with consoles. This is a less efficient solution in terms of rendering,
but at this point getting things working quickly and easily when we need to change stuff (or integrate in new
things) is the priority. I'm leaving this note for future generations to make sense of what I've done and why...

To rebuild the ButtonIcons font:
Use Window->TextMeshPro->Font Asset Creator
Settings:
 Font Source: Modified Blogger Sans-Bold.ttf
 Font Size: auto sizing
 Font padding: 5
 Packing method: optimum
 Atlas resolution: 256x256
 Character set: Unicode Range (Hex)
   -> then paste the character list below into the Character Sequence (Hex) box.
 Font Render Mode: Distance Field 32
 Don't bother with kerning - there isn't any data for these glyphs
Generate Font Atlas
Save as "ButtonIcons SDF.asset"

Character list
--------------

Cut+paste this single line into the box (no line feeds):

--cut here--
20BB,20BC,20BD,20BE,20BF,20C0,20C1,20C2,20C3,20C4,20C5,20C6,20C7,20C8,20C9,20CA,20CB,20CC,20CD,20CE,20D0,20D1,20D2,20D3,20D4,20FD,20FE,20FF,2101,2102,2103,2104,2105,2106,2107,2108,2109,210A,210B,210C,210D,210E,210F,2110,2111,2112,2113,2114,2115,2116,2117,2118,2119,211A,211B,211C,211D,211E,211F
--cut here--

Other changes
-------------

The console branch had other differences in the font asset (and the associated materials). Mainly, the atlas
resolution was 1024x1024 in the console branch (not 512x512), and scale factors in the material were different.
I don't know the exact reasons for these changes, but it may be a mix of raising the resolution for (eg.) 4K
support, making the tpage bigger to fit on the extra button icons, and adjusting the point size to make the
button icons fit whilst waiting the least space.


Button icons
------------

(These are from inspection - I might be wrong about what I'm looking at! If you import the ttf and set your
display font correctly, you should be able to see what they look like, and cut+paste them directly.)

20BB (₻) Sony Circle
20BC (₼) PS3 L1 [rectangle]
20BD (₽) PS3 L2 [rectangle]
20BE (₾) PS3 R1 [rectangle]
20BF (₿) Sony/PS4 R stick
20C0 (⃀) PS3 SELECT (Sony horizontal SELECT button)
20C1 (⃁) Sony Square
20C2 (⃂) Sony/PS4 L stick
20C3 (⃃) ?? L button [rectangle]
20C4 (⃄) ?? R button [rectangle]
20C5 (⃅) PS3 R2 [rectangle]
20C6 (⃆) Vita Front touch screen
20C7 (⃇) PS4 Touch panel
20C8 (⃈) PS3 START (Sony Start button, wedge) [not PS4]
20C9 (⃉) Sony Triangle
20CA (⃊) Sony X
20CB (⃋) Vita START [ellipse]
20CC (⃌) Vita SELECT [ellipse]
20CD (⃍) Vita L [curved button]
20CE (⃎) Vita R [curved button]
20D0 (⃐) PS4/Sony dpad
20D1 (⃑) PS4 Share
20D2 (⃒) PS4 Options
20D3 (⃓) PS4/Sony L3
20D4 (⃔) PS4/Sony R3
20FD (⃽) Xb1 A
20FE (⃾) Xb1 B
20FF (⃿) Xb1 dpad
2101 (℁) Xbox Guide button
2102 (ℂ) Xb1 LB (curved rectangle)
2103 (℃) Xb1 L stick (L black circle)
2104 (℄) Xb1 R stick (R black circle)
2105 (℅) Xb1 RB (curved rectangle)
2106 (℆) Xb1 menu (3 horizontal lines on a circle)
2107 (ℇ) Xb1 Y
2108 (℈) Xb1 X
2109 (℉) Xb1 dpad up
210A (ℊ) Xb1 dpad down
210B (ℋ) Xb1 dpad left
210C (ℌ) Xb1 dpad right
210D (ℍ) Xb1 left stick up
210E (ℎ) Xb1 left stick down
210F (ℏ) Xb1 left stick left
2110 (ℐ) Xb1 left stick right
2111 (ℑ) Xb1 right stick up
2112 (ℒ) Xb1 right stick down
2113 (ℓ) Xb1 right stick left
2114 (℔) Xb1 right stick right
2115 (ℕ) Xb1 L3 (L stick press in, side view)
2116 (№) Xb1 L3 (L stick, side view)
2117 (℗) Xb1 R3 (R stick press in, side view)
2118 (℘) Xb1 R3 (R stick, side view)
2119 (ℙ) Xb1 LT left trigger (shark fin shape)
211A (ℚ) Xb1 RT right trigger (shark fin shape)
211B (ℛ) Xb1 options (cheese slices, two overlapping rectangles on a circle)
211C (ℜ) PS4 L1 lower semi-circle
211D (ℝ) PS4 R1 lower semi-circle
211E (℞) PS4 L2 upper stretched semi-circle
211F (℟) PS4 R2 upper stretched semi-circle


PS4:
20CA (⃊) Sony X
20C1 (⃁) Sony Square
20BB (₻) Sony Circle
20C9 (⃉) Sony Triangle
211C (ℜ) PS4 L1 lower semi-circle
211D (ℝ) PS4 R1 lower semi-circle
211E (℞) PS4 L2 upper stretched semi-circle
211F (℟) PS4 R2 upper stretched semi-circle
20D3 (⃓) PS4/Sony L3
20D4 (⃔) PS4/Sony R3
20C2 (⃂) PS4 L stick
20BF (₿) PS4 R stick
20D0 (⃐) PS4/Sony dpad
20D1 (⃑) PS4 Share
20D2 (⃒) PS4 Options
20C7 (⃇) PS4 Touch panel

Xb1:
20FD (⃽) Xb1 A
20FE (⃾) Xb1 B
2108 (℈) Xb1 X
2107 (ℇ) Xb1 Y
2102 (ℂ) Xb1 LB (curved rectangle)
2105 (℅) Xb1 RB (curved rectangle)
2119 (ℙ) Xb1 LT left trigger (shark fin shape)
211A (ℚ) Xb1 RT right trigger (shark fin shape)
2103 (℃) Xb1 L stick (L black circle)
2104 (℄) Xb1 R stick (R black circle)
2115 (ℕ) Xb1 L3 (L stick press in, side view)
2116 (№) Xb1 L3 (L stick, side view)
2117 (℗) Xb1 R3 (R stick press in, side view)
2118 (℘) Xb1 R3 (R stick, side view)
2101 (℁) Xbox Guide button
2106 (℆) Xb1 menu (3 horizontal lines on a circle)
211B (ℛ) Xb1 options (cheese slices, two overlapping rectangles on a circle)
20FF (⃿) Xb1 dpad
2109 (℉) Xb1 dpad up
210A (ℊ) Xb1 dpad down
210B (ℋ) Xb1 dpad left
210C (ℌ) Xb1 dpad right
210D (ℍ) Xb1 left stick up
210E (ℎ) Xb1 left stick down
210F (ℏ) Xb1 left stick left
2110 (ℐ) Xb1 left stick right
2111 (ℑ) Xb1 right stick up
2112 (ℒ) Xb1 right stick down
2113 (ℓ) Xb1 right stick left
2114 (℔) Xb1 right stick right

PS3:
20CA (⃊) Sony X
20C1 (⃁) Sony Square
20BB (₻) Sony Circle
20C9 (⃉) Sony Triangle
20BC (₼) PS3 L1 [rectangle]
20BD (₽) PS3 L2 [rectangle]
20BE (₾) PS3 R1 [rectangle]
20C5 (⃅) PS3 R2 [rectangle]
20C0 (⃀) PS3 SELECT (Sony horizontal SELECT button)
20C8 (⃈) PS3 START (Sony Start button, wedge)

Vita:
20CA (⃊) Sony X
20C1 (⃁) Sony Square
20BB (₻) Sony Circle
20C9 (⃉) Sony Triangle
20C6 (⃆) Vita Front touch screen
20CB (⃋) Vita START [ellipse]
20CC (⃌) Vita SELECT [ellipse]
20CD (⃍) Vita L [curved button]
20CE (⃎) Vita R [curved button]

