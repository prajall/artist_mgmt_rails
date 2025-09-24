import Login from '@/pages/Login.vue'
import Homepage from '../pages/Homepage.vue'
import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', component: Homepage },
    { path: '/login', component: Login },
  ],
})

export default router
