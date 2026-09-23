-----------------------
-------- LAYOUT -------
-----------------------

hl.config({
    dwindle = {
    preserve_split = true,
    force_split = 2, -- new windows always open to the right/bottom
    split_width_multiplier = 1 -- lower = favors top/bottom splits more
},
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})
