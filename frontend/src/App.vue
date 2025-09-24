<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useAuthstore } from './stores/auth'

const authStore = useAuthstore()
const isReady = ref(false)

onMounted(async () => {
  await authStore.fetchUser()
  isReady.value = true
})
</script>

<template>
  <div v-if="!isReady" class="min-h-screen flex items-center justify-center">
    <p>Loading...</p>
  </div>

  <div v-else>
    <router-view />
  </div>
</template>

<style scoped></style>
