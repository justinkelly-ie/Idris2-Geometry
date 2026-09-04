# 🌐 Idris2-Geometry

**The 4 Fundamental Metric Geometries & 3D Spatial Lattice Topology for Idris 2**

`Idris2-Geometry` formalizes the 4 metric domain geometries and 3D spatial torus lattice topology of discrete multiset physics:

1. **Elliptic Sector** ($\det g = +1$, $27$ VM): Bound-state confinement and positive action ($Q > 0$).
2. **Hyperbolic Sector** ($\det g = -1$, $128$ DE): Electroweak gauge flux and lightcone mixing ($Q = 0$).
3. **Parabolic Sector** ($\det g = 0$, $55$ DM): Dissipation drains and null momentum ($p_{\text{null}} = (0,0)$).
4. **Substrate Sector** ($g_{12} = 1$, $210$ Budget): Causal Arrow of Time ($\Delta S \neq 0$) and Primorial $210$ allocation ($210 = 27 + 128 + 55$).

---

## Key Modules & Specifications

| Module | Architectural Role & Domain Scope |
| :--- | :--- |
| **`Geometry.LatticeTopology`** | 3D spatial coordinate vector (`Coord3D`), 27-cell torus topology ($T^3$), and discrete Laplacian flux operators ($\Delta V$). |
| **`Math.LinAlgebra.TernaryClassifier`** | 2x2 metric tensor signature classifier (`classifyTernaryMetric`), 27-state ternary matrix generator, and linear independence solver. |
| **`Math.LinAlgebra.MetricTensor`** | Discrete $2 \times 2$ metric tensor representation (`MetricTensor2D`). |
| **`Math.LawAlgebra`** | Pure algebraic Galois connections ($f_* \dashv f^*$) derived from metric MaxelTransforms. |

---

## Dependencies

- **`Idris2-Multiset-Core`**
- **`Idris2-Multiset-Transform`**
- **`Idris2-Multiset-Binary`**
- **`Idris2-Multiset-Ternary`**

---

## 🚀 Building & Installing

Built with Idris 2 (`0.8.0`):

```bash
idris2 --build Idris2-Geometry.ipkg
idris2 --install Idris2-Geometry.ipkg
```

---

© Justin Kelly. Formalized in pair-programming collaboration with Google Antigravity.
