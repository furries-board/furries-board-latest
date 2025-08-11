<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { reactive } from 'vue';

defineProps({
  errors: Object,
});

const form = reactive({
  mail: '',
  password: '',
});

async function submit() {
  router.post(route('login.process'), form);
}
</script>

<template>
  <Head title="登入" />
  <div
    class="flex min-h-screen min-w-[100vw] items-center justify-center overflow-hidden bg-surface-50"
  >
    <div class="flex flex-col items-center justify-center">
      <div
        style="
          border-radius: 56px;
          padding: 0.3rem;
          background: linear-gradient(
            180deg,
            var(--primary-color) 10%,
            rgba(33, 150, 243, 0) 30%
          );
        "
      >
        <div
          class="w-full bg-surface-0 px-8 py-20 sm:px-20"
          style="border-radius: 53px"
        >
          <div class="mb-8 flex flex-col items-center">
            <Image src="/logo.png" alt="Logo" width="60" class="my-3"></Image>
            <div class="mb-4 text-3xl font-medium text-surface-900">
              歡迎使用 Hermes
            </div>
            <span class="font-medium text-muted-color"
              >請使用 LDAP 帳密登入</span
            >
          </div>

          <div
            v-if="errors?.result"
            class="mb-2 flex flex-col items-center text-red-500"
          >
            {{ errors?.result }}
          </div>

          <form @submit.prevent="submit">
            <div class="mb-8">
              <label
                for="account"
                class="mb-2 block text-xl font-medium text-surface-900"
                >Email</label
              >
              <InputText
                id="account"
                type="text"
                placeholder="Email"
                class="mb-8 w-full md:w-[30rem]"
                v-model="form.mail"
              />
              <div v-if="errors?.mail" class="text-red-500">
                {{ errors?.mail }}
              </div>
            </div>

            <div class="mb-8">
              <label
                for="password"
                class="mb-2 block text-xl font-medium text-surface-900"
                >密碼</label
              >
              <Password
                id="password"
                placeholder="密碼"
                :toggleMask="true"
                class="mb-4"
                fluid
                :feedback="false"
                v-model="form.password"
              >
              </Password>
              <div v-if="errors?.password" class="text-red-500">
                {{ errors?.password }}
              </div>
            </div>
            <Button
              label="登入"
              class="mt-3 w-full"
              as="button"
              type="submit"
            ></Button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
