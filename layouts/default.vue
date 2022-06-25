<template>
    <v-app id="app">
		
		<NavigationDrawer :titles="titles" :drawer="showDrawer"/>
		<v-app-bar app>
			<v-app-bar-nav-icon @click="toggleDrawer()"></v-app-bar-nav-icon>
			<v-toolbar-title>{{ title }}</v-toolbar-title>
		</v-app-bar>

		<v-main>
			<Nuxt />
		</v-main>
      	
  </v-app>
  
</template>

<script>
import NavigationDrawer from '@/components/NavigationDrawer.vue'
import titles from '@/static/title.json' 

export default {
	components: {
		NavigationDrawer
	},

	data(){
		return {
			showDrawer: false,
			title: "Tipitaka Myanmar",
			titles : titles,
		}
	},

	methods: {
		toggleDrawer(){
			this.showDrawer = !this.showDrawer
		}

		
	},

	// async mounted() {
	// 	const titles = await fetch('../static/title.json');
	// 	const data = titles.json();
	// 	this.parliTitles = data;
	// 	console.log(this.parliTitles)
	// },
}
</script>
