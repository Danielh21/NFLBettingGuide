import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        "custom-dark": "#293142",
        "custom-darker": "#1f2a38",
        "custom-light": "#4a5b6c",
      },
      backgroundImage: {
        "custom-gradient": "linear-gradient(135deg, #293142, #1f2a38, #4a5b6c)",
      },
    },
  },
  plugins: [],
};
export default config;
