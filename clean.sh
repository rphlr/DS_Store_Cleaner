# Fonction pour supprimer les fichiers *.DS_Store du dossier courant et de ses sous-dossiers
function clean() {
  echo -e "\e[1m\e[32m🧹 Cleaning up .DS_Store and ._ files...\n\e[0m"

  # Compter le nombre de fichiers .DS_Store et "._"
  count=$(find . -type f \( -name '*.DS_Store' -o -name '._*' \) 2>/dev/null | wc -l)

  # Si aucun fichier n'est trouvé, afficher le message en vert
  if [ $count -eq 0 ]; then
    echo -e "\e[32m✅ No .DS_Store or ._ files found.\e[0m"
  else
    # Supprimer les fichiers .DS_Store et "._"
    i=0
    start_time=$(date +%s)
    total_time=0
    avg_time=0
    remaining_time=0

    find . -type f \( -name '*.DS_Store' -o -name '._*' \) 2>/dev/null | while read -r file; do
      let i++

      rm -f "$file"

      # Mesurer le temps total jusqu'à présent et calculer le temps moyen
      total_time=$(($(date +%s) - start_time))
      avg_time=$(echo "scale=2; $total_time/$i" | bc)

      # Estimation du temps restant (temps moyen * nombre de fichiers restants)
      remaining_files=$((count - i))
      remaining_time=$(echo "$remaining_files * $avg_time" | bc | awk '{printf("%d\n",$1 + 0.5)}')

      percent=$(echo "scale=2; $i/$count*100" | bc)
      # change color based on percentage
      if (( $(echo "$percent < 33.33" | bc -l) )); then
        color="\e[31m" # red
      elif (( $(echo "$percent < 66.67" | bc -l) )); then
        color="\e[33m" # yellow
      else
        color="\e[32m" # green
      fi

      echo -ne "\r${color}⏳ Progress: $percent% - $remaining_time sec left"

      sleep 0.1
    done

    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))

    echo -e "\e[32m\e[1m\n\n✅ All .DS_Store and ._ files have been removed.\e[0m\n\n⏳ Time elapsed:\t\t$elapsed_time seconds.\n\n🗑  Number of deleted files :\t$i\n"
  fi
}
