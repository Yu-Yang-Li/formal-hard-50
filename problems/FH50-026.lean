import Mathlib

def simplexUniformFamily (v k : ℕ) (F : Finset (Finset (Fin v))) : Prop :=
  ∀ A ∈ F, A.card = k

def simplexFreeFamily (v d : ℕ) (F : Finset (Finset (Fin v))) : Prop :=
  ¬ ∃ A : Fin (d + 1) → Finset (Fin v),
    Function.Injective A ∧
    (∀ i : Fin (d + 1), A i ∈ F) ∧
    (¬ ∃ x : Fin v, ∀ i : Fin (d + 1), x ∈ A i) ∧
    (∀ j : Fin (d + 1), ∃ x : Fin v,
      ∀ i : Fin (d + 1), i ≠ j → x ∈ A i)

noncomputable def simplexFullStar (v k : ℕ) (α : Fin v) :
    Finset (Finset (Fin v)) := by
  classical
  exact ((Finset.univ : Finset (Fin v)).powerset).filter
    (fun A => A.card = k ∧ α ∈ A)

def arxivleanConjecture : Prop :=
  ∀ (v k d : ℕ),
  2 ≤ d → d < k → (d + 1) * k ≤ d * v →
  ∀ F : Finset (Finset (Fin v)),
    simplexUniformFamily v k F →
    simplexFreeFamily v d F →
    (F.card ≤ Nat.choose (v - 1) (k - 1) ∧
      (F.card = Nat.choose (v - 1) (k - 1) ↔
        ∃ α : Fin v, F = simplexFullStar v k α))
