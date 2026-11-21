import Mathlib

theorem prime_power_sperner_family_contains_equal_union_intersection
    (r n : ℕ) (hr : 2 ≤ r) (hrpp : ∃ p k : ℕ, Nat.Prime p ∧ 1 ≤ k ∧ r = p ^ k)
    (hn : 0 < n) (𝓕 : Finset (Finset (Fin n)))
    (hSperner : ∀ ⦃A B : Finset (Fin n)⦄, A ∈ 𝓕 → B ∈ 𝓕 → A ⊆ B → A = B)
    (hcard : (r - 1) * n + 1 ≤ 𝓕.card) :
    ∃ 𝓖 : Fin r → Finset (Finset (Fin n)),
      (∀ i, (𝓖 i).Nonempty ∧ 𝓖 i ⊆ 𝓕) ∧
      (∀ ⦃i j : Fin r⦄, i ≠ j → Disjoint (𝓖 i) (𝓖 j)) ∧
      (∀ i j : Fin r, (𝓖 i).biUnion (fun A => A) = (𝓖 j).biUnion (fun A => A)) ∧
      (∀ i j : Fin r, ∀ x : Fin n,
        ((∀ A : Finset (Fin n), A ∈ 𝓖 i → x ∈ A) ↔
         (∀ A : Finset (Fin n), A ∈ 𝓖 j → x ∈ A))) := by
  sorry
