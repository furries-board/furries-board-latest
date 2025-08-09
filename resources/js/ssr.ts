import { createInertiaApp } from '@inertiajs/vue3';
import createServer from '@inertiajs/vue3/server';
import { renderToString } from '@vue/server-renderer';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { createSSRApp, h } from 'vue';
import { route as ziggyRoute } from 'ziggy-js';
import PrimeVue from 'primevue/config';
import Aura from '@primevue/themes/aura';
import Lang from '@/Lang';

const appName = import.meta.env.VITE_APP_NAME || 'Laravel';

createServer((page) =>
    createInertiaApp({
        page,
        render: async (app) => {
            try {
                return await renderToString(app);
            } catch (error) {
                console.warn('[SSR] render error (ignored):', error.message);
                return '<!-- SSR Render Error -->'; // 或空字串 ''
            }
        },
        title: (title) => `${title} - ${appName}`,
        resolve: (name) =>
            resolvePageComponent(
                `./Pages/${name}.vue`,
                import.meta.glob('./Pages/**/*.vue'),
            ),
        setup({ App, props, plugin }) {
            const app = createSSRApp({ render: () => h(App, props) });

            // Configure Ziggy for SSR...
            const ziggyConfig = {
                ...page.props.ziggy,
                location: new URL(
                    page.props.ziggy?.location || 'http://localhost',
                ),
            };

            // Create route function...
            const route = (name: string, params?: any, absolute?: boolean) =>
                ziggyRoute(name, params, absolute, ziggyConfig);

            // Make route function available globally...
            app.config.globalProperties.route = route;

            // Make route function available globally for SSR...
            if (typeof window === 'undefined') {
                global.route = route;
            }

            app.use(plugin)
                .use(Lang)
                .use(PrimeVue, {
                    theme: {
                        preset: Aura,
                        options: {
                            prefix: 'p',
                            darkModeSelector: false,
                            cssLayer: {
                                name: 'primevue',
                                order: 'tailwind-utilities, tailwind-base, primevue',
                            },
                        },
                    },
                    ripple: true,
                });

            return app;
        },
    }),
);
