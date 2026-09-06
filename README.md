# Idris2-Geometry

[![Idris 2 Verification](https://img.shields.io/badge/Idris_2-0.8.0-blue.svg)](https://www.idris-lang.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Layer 3 Discrete 4-Metric Chromogeometry Engine for Idris 2**

`Idris2-Geometry` formalizes discrete chromogeometry across the 4 fundamental metrics partitioning the Primorial 210 cosmic budget ($27 + 128 + 55 = 210$):

1. **Elliptic Geometry** ($\det g = +1$, $27$ VM): Bound-state confinement and positive metric action $Q > 0$.
2. **Hyperbolic Geometry** ($\det g = -1$, $128$ DE): Gauge flux, lightcone phase $Q = 0$, and Stern-Brocot prefix optimality.
3. **Parabolic Geometry** ($\det g = 0$, $55$ DM): Remainder dissipation drain and null momentum $p_{\text{null}} = (0, 0)$.
4. **Substrate Geometry** ($g_{22} = 0, g_{12} = 1$, $210$ Master): Asymmetric causal arrow $\Delta S \neq 0$ and discrete free energy minimization $\Delta F \le 0$.

## 🚀 Building & Installing

```bash
idris2 --build Idris2-Geometry.ipkg
idris2 --install Idris2-Geometry.ipkg
```

## 🔬 Core Modules

- **`Math.FourGeometries`**: Metric definitions, traces, determinants, and classification functions.
- **`Math.LinAlgebra.MetricTensor`**: 2D/3D symmetric metric tensor Maxels (`gBlue`, `gRed`, `gGreen`, `gSubstrate`).
- **`Geometry.LatticeTopology`**: Discrete boxel flux and toroidal lattice topology (`%macro auditToroidalBoxelFlux`).
