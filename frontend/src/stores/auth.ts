import { apiRequest } from '@/lib/api'
import type { User } from '@/types/types'
import { defineStore } from 'pinia'

interface AuthState {
  user: User | null
  isLoading: boolean
}

export const useAuthstore = defineStore('auth', {
  state: () => ({
    user: localStorage.getItem('user')
      ? (JSON.parse(localStorage.getItem('user') as string) as User)
      : null,
    isLoading: false,
  }),
  getters: {
    isAuthenticated: (state) => state.user !== null,
    getUser: (state) => state.user,
    getIsLoading: (state) => state.isLoading,
  },
  actions: {
    setUser(user: User | null) {
      this.user = user
    },
    clearUser() {
      this.user = null
    },
    setLoading(loading: boolean) {
      this.isLoading = loading
    },
    async fetchUser() {
      this.setLoading(true)
      try {
        const response = await apiRequest.get('/profile')
        console.log('User Profile Response:', response.data)
        this.setUser(response.data)
        localStorage.setItem('user', JSON.stringify(response.data))
      } catch (error) {
        this.clearUser()
        console.error('Error fetching user profile:', error)
      } finally {
        this.setLoading(false)
      }
    },
  },
})
