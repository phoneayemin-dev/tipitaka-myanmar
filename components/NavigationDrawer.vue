<template>
    <v-navigation-drawer
		v-model="drawer"
		app
	>

        <v-expansion-panels>
            <v-subheader>Title</v-subheader>
            <v-expansion-panel
                v-for="(title, key, index) in titles" :index="index" :key="key"
            >
            <v-expansion-panel-header>
                {{ title.text }}
            </v-expansion-panel-header>
            <v-expansion-panel-content v-if="Object.keys(title.parliTitles)">
                <v-list>
                    <v-list-item-group>
                        <v-list-item
                            v-for="(parLiTitle, k, i) in title.parliTitles" :index="i" :key="k"
                            link
                            :to="generateLink(parLiTitle)"
                        >
                                
                            <v-list-item-content>
                                <v-list-item-title>
                                    {{ parLiTitle.text }}
                                </v-list-item-title>
                            </v-list-item-content>
                        </v-list-item>
                    </v-list-item-group>
                </v-list>
            </v-expansion-panel-content>
            </v-expansion-panel>
        </v-expansion-panels>             
    </v-navigation-drawer>
</template>

<script>
export default{
    props: ['drawer', 'titles'],
    data() {
        return {
        }
    },
    methods: {
        generateLink(parLiTitle){
            return `/books/${parLiTitle.file}`
        }
    },
}
</script>