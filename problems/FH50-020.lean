import Mathlib

theorem cayley_ZMod_clique_free_symmetric_max_size
    (p r : ℕ) (hp : Nat.Prime p) (hpodd : Odd p)
    (hr1 : 1 ≤ r) (hrp : r ≤ p - 1) :
    (∃ S : Finset (ZMod p),
        (∀ x : ZMod p, x ∈ S → x ≠ 0) ∧
        (∀ x : ZMod p, x ∈ S → -x ∈ S) ∧
        (∀ T : Finset (ZMod p), T.card = r + 1 →
          ¬ (∀ a : ZMod p, a ∈ T → ∀ b : ZMod p, b ∈ T → a ≠ b → a - b ∈ S)) ∧
        S.card = p - 1 - 2 * (p / (r + 1))) ∧
      (∀ S : Finset (ZMod p),
        (∀ x : ZMod p, x ∈ S → x ≠ 0) →
        (∀ x : ZMod p, x ∈ S → -x ∈ S) →
        (∀ T : Finset (ZMod p), T.card = r + 1 →
          ¬ (∀ a : ZMod p, a ∈ T → ∀ b : ZMod p, b ∈ T → a ≠ b → a - b ∈ S)) →
        S.card ≤ p - 1 - 2 * (p / (r + 1))) := by
  sorry
