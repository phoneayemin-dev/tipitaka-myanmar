<template>
    <v-navigation-drawer
		v-model="drawer"
		app
	>   
        <v-list flat min-height="120px" color="#FFAB00">
            <v-list-item three-line>
                <v-list-item-content>
                    <v-list-item-title>
                        Tipitaka Myanmar
                    </v-list-item-title>
                </v-list-item-content>
            </v-list-item>
        </v-list>
        
        
        <v-divider></v-divider>
        <v-container>
            <v-list flat
                v-for="(title, key, index) in listTitles" 
                :index="index" 
                :key="key"
            >
                <v-subheader> {{ title.text }}</v-subheader>
                <v-list-item-group>
                    <v-list-item v-for="(item, ke, indx) in title.items"  
                        :index="indx" 
                        :key="ke"
                    >
                        <v-list-item-content v-if="'sub_items' in item">
                            <v-list-group>
                                <template v-slot:activator>
                                    <v-list-item-title>{{ item.text }}</v-list-item-title>
                                </template>
                                <v-list-item
                                    v-for="(parLiTitle, k, i) in item.sub_items" :index="i" :key="k"
                                    link
                                    color="#FFAB00"
                                    @click="getParLiTitle(parLiTitle.text)"
                                    :to="generateLink(parLiTitle)"
                                    ripple
                                >
                                    <v-list-item-content>
                                        {{ parLiTitle.text }}
                                    </v-list-item-content>
                                </v-list-item>
                            </v-list-group>
                        </v-list-item-content>

                        <v-list-item-content v-else>
                            <v-list-item 
                                :to="generateLink(item)"
                                @click="getParLiTitle(item.text)"
                            >
                                <v-list-item-content>
                                    {{ item.text }}
                                </v-list-item-content>
                            </v-list-item>
                        </v-list-item-content>
                </v-list-item>
                </v-list-item-group>
                
            </v-list>
        </v-container>
        
        
    </v-navigation-drawer>
</template>

<script>
export default{
    props: [
        'drawer', 
        'listTitles',
    ],
    data() {
        return {
        }
    },
    methods: {
        generateLink(parLiTitle){
            return `/books/${parLiTitle.file.name}`
        },

        getParLiTitle(title){
            this.$emit('parLiTitle', title);
        }

    },
}
</script>
<style scoped>

</style>