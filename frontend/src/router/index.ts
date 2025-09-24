import Login from '@/pages/Login.vue'
import Homepage from '../pages/Homepage.vue'
import { createRouter, createWebHistory } from 'vue-router'
import Admin from '@/pages/Admin.vue'
import { useAuthstore } from '@/stores/auth'
import Profile from '@/pages/Profile.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', component: Homepage, meta: { requiresAuth: false } },
    { path: '/login', component: Login },
    { path: '/profile', component: Profile, meta: { requiresAuth: true } },
    {
      path: '/admin',
      component: Admin,
      meta: {
        requiresAuth: true,
        allowedRoles: ['artist', 'artist_manager', 'super_admin'],
      },
    },
  ],
})

router.beforeEach(async (to) => {
  const { isLoading, isAuthenticated, user, fetchUser } = useAuthstore()

  if (!user) {
    await fetchUser()
  }
  console.log(
    'Route: ',
    to.path,
    'Requires Auth:',
    to.meta.requiresAuth,
    'isAuthenticated:',
    isAuthenticated,
    'IsLoading',
    isLoading,
    'User:',
    user,
  )

  if (to.meta.requiresAuth) {
    if (!isAuthenticated) {
      return { path: '/login' }
    }
    const allowedRoles = to.meta.allowedRoles as string[] | undefined
    if (allowedRoles && user && !allowedRoles.includes(user.role)) {
      return { path: '/' }
    }
  }
})

export default router
