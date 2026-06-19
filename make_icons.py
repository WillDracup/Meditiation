"""Draws the app icons: a simple singing bowl (elliptical rim + rounded body) in
brass on the app's dark background. No external artwork — everything is drawn here.
Run:  py make_icons.py   (needs Pillow:  py -m pip install pillow)
"""
from PIL import Image, ImageDraw

NIGHT    = (20, 18, 27)      # #14121b — app background
BRASS    = (200, 164, 92)    # #c8a45c — bowl body
BRASS_HI = (232, 201, 135)   # #e8c987 — rim highlight
INTERIOR = (120, 96, 52)     # darker brass — the opening, for a touch of depth

def draw_bowl(size, pad_frac):
    S = size * 4                                   # supersample for smooth edges
    img = Image.new("RGBA", (S, S), NIGHT + (255,))
    d = ImageDraw.Draw(img)
    pad = S * pad_frac
    avail = S - 2 * pad

    cx = S / 2
    rw = avail * 0.5 * 0.94          # rim half-width
    rh = rw * 0.28                   # rim half-height (how open the ellipse looks)
    body_h = rw * 0.92              # bowl depth (slightly shallower than a half-circle)

    total_h = rh + body_h           # rim top -> body bottom
    ry = pad + (avail - total_h) / 2 + rh   # rim-centre y, vertically centred
    by = ry + body_h                # bottom of the body

    # body: the lower half of an ellipse whose vertical centre sits on the rim line
    d.chord([cx - rw, ry - body_h, cx + rw, by], 0, 180, fill=BRASS)
    # the open rim: darker interior + a bright lip
    rim = [cx - rw, ry - rh, cx + rw, ry + rh]
    d.ellipse(rim, fill=INTERIOR)
    d.ellipse(rim, outline=BRASS_HI, width=max(2, int(S * 0.013)))

    return img.resize((size, size), Image.LANCZOS)

def save(size, name, pad_frac):
    draw_bowl(size, pad_frac).save(name)
    print("wrote", name)

save(192, "icon-192.png", 0.18)
save(512, "icon-512.png", 0.18)
save(512, "icon-maskable-512.png", 0.28)   # extra padding for the OS mask
save(180, "apple-touch-icon.png", 0.18)
print("done")
