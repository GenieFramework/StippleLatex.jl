!function(e,t){"object"==typeof exports&&"undefined"!=typeof module?module.exports=t(require("katex"),require("katex/dist/contrib/auto-render.js")):"function"==typeof define&&define.amd?define(["katex","katex/dist/contrib/auto-render.js"],t):(e=e||self).VueKatex=t(e.katex,e.renderMathInElement)}(this,(function(e,t){"use strict";e=e&&Object.prototype.hasOwnProperty.call(e,"default")?e.default:e,t=t&&Object.prototype.hasOwnProperty.call(t,"default")?t.default:t;var o=require("deepmerge"),r=require("deepmerge");function n(e,t,o,r,n,i,a,d,s,l){"boolean"!=typeof a&&(s=d,d=a,a=!1);var u,p="function"==typeof o?o.options:o;if(e&&e.render&&(p.render=e.render,p.staticRenderFns=e.staticRenderFns,p._compiled=!0,n&&(p.functional=!0)),r&&(p._scopeId=r),i?(u=function(e){(e=e||this.$vnode&&this.$vnode.ssrContext||this.parent&&this.parent.$vnode&&this.parent.$vnode.ssrContext)||"undefined"==typeof __VUE_SSR_CONTEXT__||(e=__VUE_SSR_CONTEXT__),t&&t.call(this,s(e)),e&&e._registeredComponents&&e._registeredComponents.add(i)},p._ssrRegister=u):t&&(u=a?function(e){t.call(this,l(e,this.$root.$options.shadowRoot))}:function(e){t.call(this,d(e))}),u)if(p.functional){var c=p.render;p.render=function(e,t){return u.call(t),c(e,t)}}else{var f=p.beforeCreate;p.beforeCreate=f?[].concat(f,u):[u]}return o}var i=n({},void 0,{name:"KatexElement",props:{expression:{type:String,default:"",required:!0},displayMode:{type:Boolean,default:void 0},throwOnError:{type:Boolean,default:void 0},errorColor:{type:String,default:void 0},macros:{type:Object,default:void 0},colorIsTextColor:{type:Boolean,default:void 0},maxSize:{type:Number,default:void 0},maxExpand:{type:Number,default:void 0},allowedProtocols:{type:Array,default:void 0},strict:{type:[Boolean,String,Function],default:void 0}},computed:{options:function(){return r(this.$katexOptions,(e={displayMode:this.displayMode,throwOnError:this.throwOnError,errorColor:this.errorColor,macros:this.macros,colorIsTextColor:this.colorIsTextColor,maxSize:this.maxSize,maxExpand:this.maxExpand,allowedProtocols:this.allowedProtocols,strict:this.strict},t={},Object.keys(e).forEach((function(o){void 0!==e[o]&&(t[o]=e[o])})),t));var e,t},math:function(){return e.renderToString(this.expression,this.options)}},render:function(e){return e(this.displayMode?"div":"span",{domProps:{innerHTML:this.math}})}},void 0,void 0,void 0,!1,void 0,void 0,void 0),a={install:function(r,n){var a=n&&n.globalOptions||{},d=function(r){return{name:"katex",directive:function(n,i){var a=i.value&&i.value.options||{},d=o(r,a);if(i.arg&&"auto"===i.arg)t(n,d);else{var s=i.value.expression||i.value,l={};"display"===i.arg&&(l.displayMode=!0);var u=o(d,l);e.render(s,n,u)}}}}(a);r.directive(d.name,d.directive),r.component(i.name,i),r.prototype.$katexOptions=a}};return"undefined"!=typeof window&&window.Vue&&window.Vue.use(a),a}));