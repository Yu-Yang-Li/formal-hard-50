import Mathlib

def LabelledStarForest (m : ℕ) (G : SimpleGraph (Fin m)) : Prop :=
  ∃ center : Fin m → Fin m,
    (∀ v, center (center v) = center v) ∧
    (∀ u v, G.Adj u v ↔
      u ≠ v ∧ center u = center v ∧
        (u = center u ∨ v = center v))

def CommonGraphCopy (m n : ℕ) (F : SimpleGraph (Fin m))
    (G H : SimpleGraph (Fin n)) : Prop :=
  ∃ f : Fin m → Fin n,
    Function.Injective f ∧
    ∀ u v, F.Adj u v →
      G.Adj (f u) (f v) ∧ H.Adj (f u) (f v)

def GraphIntersectingFamily (m n : ℕ) (F : SimpleGraph (Fin m))
    (family : Finset (SimpleGraph (Fin n))) : Prop := by
  classical
  exact ∀ G ∈ family, ∀ H ∈ family, CommonGraphCopy m n F G H

def arxivleanConjecture : Prop :=
  ∃ ε : ℝ, 0 < ε ∧
  ∀ (m : ℕ) (F : SimpleGraph (Fin m)),
    ¬ LabelledStarForest m F →
    ∀ (n : ℕ) (family : Finset (SimpleGraph (Fin n))),
      GraphIntersectingFamily m n F family →
      (family.card : ℝ) ≤
        ((1 : ℝ) / 2 - ε) * (2 : ℝ) ^ (n * (n - 1) / 2)
