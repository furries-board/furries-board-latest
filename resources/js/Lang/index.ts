import { createI18n } from 'vue-i18n';
import en_US from './en_US.json';
import zh_TW from './zh_TW.json';

const i18n = createI18n({
  legacy: false,
  locale: 'zh-TW',
  fallbackLocale: 'en-US',
  messages: {
    'zh-TW': zh_TW,
    'en-US': en_US,
  },
});

export default i18n;
