<template>
    <v-app id="app">
		
		<NavigationDrawer 
			:drawer="showDrawer" 
			@parLiTitle="getParLiTitle"

			:listTitles="listTitles" 
		/>

		<v-app-bar app dense flat color="#FFC400">
			<v-app-bar-nav-icon @click="toggleDrawer()"></v-app-bar-nav-icon>
			<v-toolbar-title>{{ parLiTitle }}</v-toolbar-title>
		</v-app-bar>

		<v-main>
			<Nuxt />
		</v-main>
      	
  </v-app>
  
</template>

<script>
import NavigationDrawer from '@/components/NavigationDrawer.vue'
import titles from '@/static/categorize-titles.json' 

export default {
	components: {
		NavigationDrawer
	},
	data(){
		return {
			showDrawer: false,
			parLiTitle: "Tipitaka Myanmar",
			listTitles: titles,
		}
	},

	methods: {
		toggleDrawer(){
			this.showDrawer = !this.showDrawer
		},
		getParLiTitle(value) {
			this.parLiTitle = value
		},
		
	},

	// async mounted() {
	// 	const titles = await fetch('../static/title.json');
	// 	const data = titles.json();
	// 	this.parliTitles = data;
	// 	console.log(this.parliTitles)
	// },
}
</script>
<!-- <style lang="scss">
@import '~/assets/variables.scss';

::-webkit-scrollbar {
	width: $web-kit-scrollbar-width;
	background-color: $web-kit-scrollbar-background-color;
	/* overflow: scroll; */
}

::-webkit-scrollbar-thumb{
	background: $web-kit-scrollbar-thum-background;
	height: $web-kit-scrollbar-thum-height;
	border-radius: $web-kit-scrollbar-thum-border-radius;
}

</style> -->
