# 🌐 Idris2-Geometry3

**The 4 Fundamental Metric Geometries for Idris 2**

`Idris2-Geometry3` formalizes the 4 metric domain geometries of discrete physics:
1. **Elliptic Sector** ($\det g = +1$, $27$ VM): Bound-state confinement and positive action ($Q > 0$).
2. **Hyperbolic Sector** ($\det g = -1$, $128$ DE): Electroweak gauge flux and lightcone mixing ($Q = 0$).
3. **Parabolic Sector** ($\det g = 0$, $55$ DM): Dissipation drains and null momentum ($p_{\text{null}} = (0,0)$).
4. **Substrate Sector** ($g_{12} = 1$, $210$ Budget): Causal Arrow of Time ($\Delta S \neq 0$) and Primorial $210$ allocation ($210 = 27 + 128 + 55$).

---

## 🚀 Building & Installing

Built with Idris 2 (`0.8.0`):

```bash
idris2 --build Idris2-Geometry3.ipkg
idris2 --install Idris2-Geometry3.ipkg
```

---

## 🔬 Language & Framework Integration

Written in **Idris 2** enforcing total constructivism (`%default total`).
