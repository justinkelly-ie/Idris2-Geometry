module Geometry.MonadicMetricSpace

import Data.Vect
import Core.BoxInt
import Core.UnixelFraction
import Core.Goh
import Core.Order.Preorder
import Geometry.Applicative
import Geometry.MetricalBounds

%default total

--------------------------------------------------------------------------------
-- UNIFIED MONADIC METRIC SPACE CONTRACT
--------------------------------------------------------------------------------

||| Unified Interface combining Applicative envelopes with preordered monoidal bounds
||| and poset directional steps.
public export
interface Applicative m => MonadicMetricSpace (0 m : Type -> Type) where
  ||| Metric signature constraint validator
  validateMetricBound : {0 a : Type} -> m a -> Bool

public export
implementation {dim : Nat} -> {color : MetricColor} -> MonadicMetricSpace (GeometricEnvelope dim color) where
  validateMetricBound _ = True

public export
implementation {dim : Nat} -> {color : MetricColor} -> MonadicMetricSpace (MetricalEnvelope dim color) where
  validateMetricBound _ = True
