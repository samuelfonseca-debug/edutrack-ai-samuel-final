import streamlit as st

st.title("Meu Perfil")
st.markdown("---")

col1, col2 = st.columns([1, 2])

with col1:
    st.info("👤 Usuário")
    
with col2:
    st.write("**Nome:** Samuel Mariano da Fonseca")
    st.write("**Curso:** Innovation Lab: Desenvolvimento Avançado No/Low Code")