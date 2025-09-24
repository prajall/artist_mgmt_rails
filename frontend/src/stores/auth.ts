import type { User } from '@/types/types'
import { defineStore } from 'pinia'

export const useAuthstore = defineStore('auth', {
  state: () => ({
    user: null as User | null,
  }),
  actions: {
    setUser(user: User | null) {
      this.user = user
    },
    clearUser() {
      this.user = null
    },
  },
})
